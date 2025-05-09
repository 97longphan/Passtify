//
//  DeletedPasswordListView.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import SwiftUI


struct DeletedPasswordListView: View {
    @ObservedObject var viewModel: DeletedPasswordListViewModel

    var body: some View {
        List {
            if viewModel.filteredList.isEmpty {
                DeletedPasswordListEmptyView()
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(viewModel.filteredList, id: \.id) { item in
                    PasswordListCardItemView(passwordItem: item) {
                        viewModel.onActionSelectItem(item: item)
                    }
                    .listRowInsets(EdgeInsets()) // remove default padding
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(.plain)
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Đã xoá gần đây")
        .searchable(text: $viewModel.searchTerm, prompt: "Tìm kiếm")
    }
}

