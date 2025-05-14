import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var toastManager: ToastManager
    @State private var currentTipKey: String = "key.default_tip_text"
    @ObservedObject var lang = LocalizationManager.shared
    
    private let tipKeys = (0..<10).map { "key.tip_\($0)" }
    
    var body: some View {
        List {
            // PASSWORD SECTION
            Section(header: Text("key.password".localized)) {
                ForEach(viewModel.categories.filter { $0.type.group == .password }) { item in
                    Button {
                        viewModel.handleCategoryTap(item: item)
                    } label: {
                        HomeListItemView(item: item)
                    }
                }
            }
            
            // DATA SECTION
            Section(header: Text("key.data".localized)) {
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
                        title: ("key.security_tip_title".localized),
                        subtitle: currentTipKey.localized,
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
        .navigationBarItems(trailing:
                                Button(action: {
            lang.currentLanguage = lang.currentLanguage.toggled
        }) {
            Text(lang.currentLanguage.toggled.flag)
            .font(.system(size: 24))}
        )
        .onAppear {
            viewModel.loadCount()
        }
        .onReceive(viewModel.$toastMessage.compactMap { $0 }) { msg in
            toastManager.show(msg, type: .error)
        }
    }
    
    private func updateTip() {
        withAnimation(.easeInOut(duration: 0.25)) {
            currentTipKey = tipKeys.filter { $0 != currentTipKey }.randomElement() ??   tipKeys.first!
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
