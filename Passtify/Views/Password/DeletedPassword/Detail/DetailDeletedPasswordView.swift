//
//  DetailDeletedPasswordView.swift
//  Passtify
//
//  Created by LONGPHAN on 5/5/25.
//

import SwiftUI

struct DetailDeletedPasswordView: View {
    @ObservedObject var viewModel: DetailDeletedPasswordViewModel
    @State private var showActionSheetDelete = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(viewModel.passwordItem.label.prefix(1).uppercased())
                                .font(.title)
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.passwordItem.label)
                            .font(.headline)
                            .bold()
                        Text(String(format: "key.modified_value".localized, formattedDate(viewModel.passwordItem.creationDate)))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section(header: Text("key.login_info".localized)) {
                HStack {
                    Text("key.username".localized)
                    Spacer()
                    Text(viewModel.passwordItem.userName)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("key.password".localized)
                    Spacer()
                    Text("••••••••")
                        .foregroundColor(.secondary)
                }
            }
            
            Section {
                Button("key.restore".localized) {
                    viewModel.recoverPassword()
                }
                .foregroundColor(.blue)
                
                Button("key.delete".localized) {
                    viewModel.permanentlyDeletePassword()
                }
                .foregroundColor(.red)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
