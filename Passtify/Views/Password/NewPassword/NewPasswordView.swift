//
//  NewPasswordView.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import SwiftUI

struct NewPasswordView: View {
    @ObservedObject var viewModel: NewPasswordViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.yellow)
                            .padding(.leading, 4)
                        
                        TextField("Trang web hoặc nhãn", text: $viewModel.input.label)
                            .font(.headline)
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        Text("Tên người dùng")
                        Spacer()
                        TextField("người dùng", text: $viewModel.input.userName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Mật khẩu")
                        Spacer()
                        SecureField("mật khẩu", text: $viewModel.input.password)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("GHI CHÚ").font(.caption).foregroundColor(.gray)) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: Binding(
                            get: { viewModel.input.notes ?? "" },
                            set: { viewModel.input.notes = $0.isEmpty ? nil : $0 }
                        ))
                        .frame(height: 100)
                        .foregroundColor((viewModel.input.notes ?? "").isEmpty ? .gray : .primary)
                        
                        if (viewModel.input.notes ?? "").isEmpty {
                            Text("Thêm Ghi chú")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.horizontal, 5)
                        }
                    }
                }
            }
            .navigationBarTitle("Mật khẩu mới", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Hủy") {
                    viewModel.onDissmissNewPassword()
                },
                trailing: Button("Lưu") {
                    viewModel.onSaveNewPassword()
                }
                .bold()
                .disabled(!viewModel.isFormValid())
            )
        }
    }
}


#Preview {
    NewPasswordView(viewModel: NewPasswordViewModel(passwordService: PasswordService()))
}
