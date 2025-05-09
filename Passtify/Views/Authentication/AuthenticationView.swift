//
//  AuthenticationGateView.swift
//  Passtify
//
//  Created by LONGPHAN on 7/5/25.
//

import SwiftUI

struct AuthenticationView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var session: AppSession
    @ObservedObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "key.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.yellow)
                    
                    
                    Text("Mật khẩu đã bị khóa")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Button("Mở khóa") {
                        viewModel.authenticate { success in
                            if success {
                                session.isAuthenticated = true
                            }
                        }
                    }
                    .font(.headline)
                    .foregroundColor(Color.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .cornerRadius(14)
                }
                .padding(30)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(24)
                .shadow(color: Color.primary.opacity(0.15), radius: 12, x: 0, y: 4)
            }
            .padding()
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active && !viewModel.didCancelLastAttempt {
                viewModel.authenticate { success in
                    if success {
                        session.isAuthenticated = true
                    }
                }
            }
        }
    }
}


#Preview {
    AuthenticationView(viewModel: AuthenticationViewModel(authService: AuthService()))
}
