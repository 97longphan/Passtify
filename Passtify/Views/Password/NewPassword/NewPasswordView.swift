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
                        
                        TextField("key.website_or_label".localized, text: $viewModel.input.label)
                            .font(.headline)
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        Text("key.username".localized)
                        Spacer()
                        TextField("key.user".localized, text: $viewModel.input.userName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("key.password".localized)
                        Spacer()
                        SecureField("key.password".localized, text: $viewModel.input.password)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("key.note".localized).font(.caption).foregroundColor(.gray)) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: Binding(
                            get: { viewModel.input.notes ?? "" },
                            set: { viewModel.input.notes = $0.isEmpty ? nil : $0 }
                        ))
                        .frame(height: 100)
                        .foregroundColor((viewModel.input.notes ?? "").isEmpty ? .gray : .primary)
                        
                        if (viewModel.input.notes ?? "").isEmpty {
                            Text("key.add_note".localized)
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.horizontal, 5)
                        }
                    }
                }
            }
            .navigationBarTitle("key.new_password".localized, displayMode: .inline)
            .navigationBarItems(
                leading: Button("key.cancel".localized) {
                    viewModel.onDissmissNewPassword()
                },
                trailing: Button("key.save".localized) {
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
