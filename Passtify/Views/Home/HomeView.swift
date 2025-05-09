import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var toastManager: ToastManager
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
        .navigationTitle("Passtify")
        .onAppear {
            viewModel.loadCount()
        }
        .onReceive(viewModel.$toastMessage.compactMap { $0 }) { msg in
            toastManager.show(msg, type: .error)
        }
    }
    
    private func updateTip() {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentTip = securityTips.filter { $0 != currentTip }.randomElement() ?? ""
        }
    }

}

struct ListFooterView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Passtify \(Bundle.main.appVersionDisplay)")
                .font(.footnote)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.vertical, 20)
    }
}

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
