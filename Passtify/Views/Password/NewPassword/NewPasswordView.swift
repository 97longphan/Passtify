//
//  NewPasswordView.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import SwiftUI

struct NewPasswordView: View {
    @Bindable var viewModel: NewPasswordViewModel
    
    @State private var title: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var note: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.yellow)
                            .padding(.leading, 4)
                        
                        TextField("Trang web hoặc nhãn", text: $title)
                            .font(.headline)
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        Text("Tên người dùng")
                        Spacer()
                        TextField("người dùng", text: $username)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Mật khẩu")
                        Spacer()
                        SecureField("mật khẩu", text: $password)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("GHI CHÚ").font(.caption).foregroundColor(.gray)) {
                    TextEditor(text: $note)
                        .frame(height: 100)
                        .foregroundColor(note.isEmpty ? .gray : .primary)
                        .overlay(
                            Group {
                                if note.isEmpty {
                                    Text("Thêm Ghi chú")
                                        .foregroundColor(.gray)
                                        .padding(.top, 8)
                                        .padding(.horizontal, 5)
                                }
                            }, alignment: .topLeading
                        )
                }
            }
            .navigationTitle("Mật khẩu mới")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Hủy") {
                        viewModel.onDissmissNewPassword()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lưu") {
                        viewModel.onSaveNewPassword()
                    }
                    .bold()
                }
            }
        }
        
    }
}

#Preview {
    NewPasswordView(viewModel: NewPasswordViewModel(passwordService: PasswordService()))
}
