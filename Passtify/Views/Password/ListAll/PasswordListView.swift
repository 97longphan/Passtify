//
//  PasswordListView.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import SwiftUI

struct PasswordListView: View {
    @ObservedObject var viewModel: PasswordListViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                if viewModel.groupedList.isEmpty {
                    Section {
                        PasswordListEmptyView()
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                } else {
                    ForEach(viewModel.groupedList.keys.sorted(), id: \.self) { key in
                        Section(header: Text(key)) {
                            ForEach(viewModel.groupedList[key]!, id: \.id) { item in
                                PasswordListCardItemView(passwordItem: item) {
                                    viewModel.onActionSelectItem(item: item)
                                }
                                .listRowInsets(EdgeInsets()) // remove padding
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .background(Color(UIColor.systemGroupedBackground))
            .searchable(text: $viewModel.searchTerm, prompt: "Tìm kiếm")
            .navigationTitle("Mật khẩu")
            .onAppear {
                viewModel.loadPasswords()
            }
            
            // Nút tạo mới
            Button(action: {
                viewModel.onActionCreateNewPassword()
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.accentColor)
                    .padding()
                    .background(Color.accentColor.opacity(0.15))
                    .clipShape(Circle())
            }
            .padding()
        }
    }
}
