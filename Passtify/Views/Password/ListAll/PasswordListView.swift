//
//  PasswordListView.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import SwiftUI

struct PasswordListView: View {
    @ObservedObject var viewModel: PasswordListViewModel
    @State private var searchTerm = ""
    
    // Lọc danh sách theo searchTerm
    private var filteredList: [PasswordItemModel] {
        if searchTerm.isEmpty {
            return viewModel.passwordList
        } else {
            return viewModel.passwordList.filter {
                $0.label.localizedCaseInsensitiveContains(searchTerm) ||
                $0.userName.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    var body: some View {
        VStack {
            if filteredList.isEmpty {
                EmptyPasswordListView()
            } else {
                List {
                    ForEach(filteredList) { item in
                        Button {
                            viewModel.onActionSelectItem(item: item)
                        } label: {
                            PasswordListItemView(passwordItem: item)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color(UIColor.systemBackground))
                .searchable(text: $searchTerm, prompt: "Tìm kiếm")
            }
            
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    viewModel.onActionCreateNewPassword()
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.accentColor)
                }
                .padding()
            }
        }.navigationTitle("Tất cả")
    }
}

struct EmptyPasswordListView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "key")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("Không có mật khẩu đã lưu")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Mật khẩu được lưu tự động khi đăng nhập vào các trang web và ứng dụng.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground)) // Tự động đổi theo Light/Dark Mode
    }
}



#Preview {
    PasswordListView(viewModel: PasswordListViewModel(passwordService: PasswordService()))
}


