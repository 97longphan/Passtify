//
//  PasswordListView.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import SwiftUI

struct PasswordListView: View {
    @Bindable var viewModel: PasswordListViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.passwordList) { item in
                    PasswordListItemView(passwordItem: item)
                        .listRowInsets(EdgeInsets()) // Loại bỏ insets mặc định
                }
                .onDelete { _ in
                    print("Delete")
                }
            }
            .listStyle(.plain)
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("Tất cả")
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    viewModel.onActionCreateNewPassword()
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .font(.largeTitle)
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
