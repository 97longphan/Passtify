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
            .navigationTitle("Tất cả")
            .searchable(text: $searchTerm, prompt: "Tìm kiếm")

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
        }
    }
}



#Preview {
    PasswordListView(viewModel: PasswordListViewModel(passwordService: PasswordService()))
}


