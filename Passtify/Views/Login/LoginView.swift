//
//  LoginView.swift
//  Passtify
//
//  Created by LONGPHAN on 29/4/25.
//

import SwiftUI

struct LoginView: View {
    @Bindable var viewModel: LoginViewModel
    
    var body: some View {
            VStack(spacing: 40) {
                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .frame(width: 24, height: 32)
                        .foregroundColor(.gray)

                    Text("Mật khẩu đã bị khoá")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }

                Button(action: {
                    viewModel.signInWithGoogle()
                }) {
                    HStack {
                        Image("google")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Đăng nhập với Google")
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
}

#Preview {
    LoginView(viewModel: LoginViewModel(authService: AuthService(googleService: GoogleService(), firebaseService: FirebaseService())))
}
