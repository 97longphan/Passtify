//
//  CredentialRootView.swift
//  Passtify
//
//  Created by Phan Hoang Long on 18/5/25.
//

import SwiftUI
import AuthenticationServices

struct CredentialRootView: View {
    let credentials: [PasswordItemModel]
    let onSelect: (PasswordItemModel) -> Void
    let onCancel: () -> Void

    @StateObject private var lockScreenViewModel = LockScreenViewModel()
    @State private var isUnlocked = false
    @State private var showError = false

    var body: some View {
        Group {
            if isUnlocked {
                CredentialListView(credentials: credentials, onSelect: onSelect, onCancel: onCancel)
            } else {
                LockScreenView(viewModel: lockScreenViewModel)
            }
        }
        .onChange(of: lockScreenViewModel.result) { result in
            guard let result else { return }
            switch result {
            case .success:
                isUnlocked = true
            case .failure:
                showError = true
            }
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Xác thực thất bại"),
                message: Text("Không thể xác minh danh tính."),
                dismissButton: .default(Text("Đóng"), action: onCancel)
            )
        }
    }
}


