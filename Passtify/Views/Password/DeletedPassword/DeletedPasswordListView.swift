//
//  DeletedPasswordListView.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import SwiftUI

struct DeletedPasswordListView: View {
    @ObservedObject var viewModel: DeletedPasswordListViewModel
    @State private var searchTerm = ""
    
    // Lọc danh sách theo searchTerm
    private var filteredList: [PasswordItemModel] {
        if searchTerm.isEmpty {
            return viewModel.deletedPasswordList
        } else {
            return viewModel.deletedPasswordList.filter {
                $0.label.localizedCaseInsensitiveContains(searchTerm) ||
                $0.userName.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    var body: some View {
        Group {
            if filteredList.isEmpty {
                EmptyRecentlyDeletedView()
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
                .searchable(text: $searchTerm, prompt: "Tìm kiếm")
            }
        }
        .background(Color(UIColor.systemBackground))
        .navigationTitle("Đã xoá gần đây")
    }
}

struct EmptyRecentlyDeletedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "trash")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("Không có mật khẩu đã xoá")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Các mật khẩu và mã khoá đã xoá sẽ có sẵn tại đây trong 30 ngày, trước khi bị xoá tự động.")
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
    DeletedPasswordListView(viewModel: DeletedPasswordListViewModel(passwordService: PasswordService()))
}


