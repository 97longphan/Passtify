import SwiftUI
import Combine

// MARK: - ENUM & MODEL

enum HomeItemCategoryGroup {
    case password
    case data
}

enum HomeItemCategoryType: CaseIterable, Identifiable {
    case password
    case deleted
    case importData
    case exportData

    var id: Self { self }

    var title: String {
        switch self {
        case .password: return "Tất cả"
        case .deleted: return "Đã xoá"
        case .importData: return "Nhập dữ liệu"
        case .exportData: return "Xuất dữ liệu"
        }
    }

    var subtitle: String {
        switch self {
        case .password: return "Tất cả các mật khẩu bạn đã lưu"
        case .deleted: return "Mật khẩu đã xoá gần đây"
        case .importData: return "Khôi phục dữ liệu từ file backup"
        case .exportData: return "Sao lưu dữ liệu ra file ZIP"
        }
    }

    var iconName: String {
        switch self {
        case .password: return "key.fill"
        case .deleted: return "trash.fill"
        case .importData: return "square.and.arrow.down.fill"
        case .exportData: return "square.and.arrow.up.fill"
        }
    }

    var iconBackgroundColor: Color {
        switch self {
        case .password: return .blue
        case .deleted: return .red
        case .importData: return .green
        case .exportData: return .orange
        }
    }

    var isShowCount: Bool {
        switch self {
        case .password, .deleted: return true
        default: return false
        }
    }

    var group: HomeItemCategoryGroup {
        switch self {
        case .password, .deleted: return .password
        case .importData, .exportData: return .data
        }
    }
}

struct HomeItemCategoryModel: Identifiable {
    let id = UUID()
    let type: HomeItemCategoryType
    var count: Int
}

// MARK: - VIEWMODEL

protocol HomeViewModelDelegate: AnyObject {
    func didPressPassword()
    func didPressDeletedPassword()
    func didExportData(url: URL)
    func didImportData()
}

class HomeViewModel: ObservableObject {
    private weak var delegate: HomeViewModelDelegate?
    private var cancellables = Set<AnyCancellable>()
    private let passwordService: PasswordServiceProtocol
    private let fileService: FileServiceProtocol

    init(passwordService: PasswordServiceProtocol, fileService: FileServiceProtocol) {
        self.passwordService = passwordService
        self.fileService = fileService
    }

    @Published var categories: [HomeItemCategoryModel] = HomeItemCategoryType.allCases.map {
        HomeItemCategoryModel(type: $0, count: 0)
    }

    func setup(delegate: HomeViewModelDelegate) -> Self {
        self.delegate = delegate
        loadCount()
        return self
    }

    func handleCategoryTap(item: HomeItemCategoryModel) {
        switch item.type {
        case .password:
            delegate?.didPressPassword()
        case .deleted:
            delegate?.didPressDeletedPassword()
        case .exportData:
            fileService.exportEncryptedDataAsZip()
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Export failed:", error)
                    }
                } receiveValue: { [weak self] url in
                    self?.delegate?.didExportData(url: url)
                }.store(in: &cancellables)
        case .importData:
            delegate?.didImportData()
        }
    }

    func importDataFrom(url: URL) {
        fileService.importEncryptedDataFromZip(url)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Import failed:", error)
                }
            } receiveValue: { [weak self] _ in
                self?.loadCount()
            }.store(in: &cancellables)
    }

    private func updateCount(for type: HomeItemCategoryType, count: Int) {
        if let index = categories.firstIndex(where: { $0.type == type }) {
            categories[index].count = count
        }
    }

    func loadCount() {
        passwordService.loadPasswords()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] passwords in
                self?.updateCount(for: .password, count: passwords.count)
            }
            .store(in: &cancellables)

        passwordService.loadDeletedPasswords()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] deleted in
                self?.updateCount(for: .deleted, count: deleted.count)
            }
            .store(in: &cancellables)
    }
}

// MARK: - VIEW
struct BannerListItemView: View {
    let title: String
    let subtitle: String
    let iconName: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 36, height: 36)

                Image(systemName: iconName)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .transition(.opacity) // Thêm hiệu ứng fade
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var currentTip: String = "Click vô đây tôi cho bạn tip nè ^^"
    private let securityTips = [
        "Đừng dùng chung một mật khẩu cho nhiều tài khoản.",
        "Hãy bật xác thực hai yếu tố (2FA) khi có thể.",
        "Mật khẩu mạnh nên có ký tự đặc biệt, chữ hoa và số.",
        "Không lưu mật khẩu vào ghi chú không mã hoá.",
        "Sử dụng trình quản lý mật khẩu để lưu trữ an toàn.",
        "Mỗi tài khoản nên có một mật khẩu riêng biệt.",
        "Tránh dùng thông tin cá nhân trong mật khẩu.",
        "Không chia sẻ mật khẩu qua tin nhắn hay email.",
        "Thường xuyên cập nhật mật khẩu định kỳ.",
        "Tránh dùng Wi-Fi công cộng khi đăng nhập tài khoản."
    ]

    private var randomTip: String {
        securityTips.randomElement() ?? ""
    }

    var body: some View {
        List {
            // PASSWORD SECTION
            Section(header: Text("Mật khẩu")) {
                ForEach(viewModel.categories.filter { $0.type.group == .password }) { item in
                    Button {
                        viewModel.handleCategoryTap(item: item)
                    } label: {
                        HomeListItemView(item: item)
                    }
                }
            }

            // DATA SECTION
            Section(header: Text("Dữ liệu")) {
                ForEach(viewModel.categories.filter { $0.type.group == .data }) { item in
                    Button {
                        viewModel.handleCategoryTap(item: item)
                    } label: {
                        HomeListItemView(item: item)
                    }
                }
            }
            
            Section {
                Button {
                    updateTip()
                } label: {
                    BannerListItemView(
                        title: "Mẹo bảo mật",
                        subtitle: currentTip,
                        iconName: "lightbulb.fill"
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            // VERSION FOOTER
            ListFooterView()
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Mật khẩu")
        .onAppear {
            viewModel.loadCount()
        }
    }
    
    private func updateTip() {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentTip = securityTips.filter { $0 != currentTip }.randomElement() ?? ""
        }
    }

}

struct HomeListItemView: View {
    let item: HomeItemCategoryModel

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(item.type.iconBackgroundColor)
                    .frame(width: 44, height: 44)
                Image(systemName: item.type.iconName)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.type.title)
                    .font(.body)
                Text(item.type.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if item.type.isShowCount {
                Text("\(item.count)")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle())
    }
}

struct ListFooterView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Passtify v1.0")
                .font(.footnote)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.vertical, 20)
    }
}
