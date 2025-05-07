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
                        Text("Sửa đổi: \(formattedDate(viewModel.passwordItem.creationDate))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section(header: Text("Thông tin đăng nhập")) {
                HStack {
                    Text("Tên người dùng")
                    Spacer()
                    Text(viewModel.passwordItem.userName)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Mật khẩu")
                    Spacer()
                    Text("••••••••")
                        .foregroundColor(.secondary)
                }
            }
            
            Section {
                Button("Khôi phục") {
                    viewModel.recoverPassword()
                }
                .foregroundColor(.blue)
                
                Button("Xóa") {
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
