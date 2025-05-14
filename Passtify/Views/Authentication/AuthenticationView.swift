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
    @ObservedObject var lang = LocalizationManager.shared
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "key.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.yellow)
                    Text("key.password_has_been_locked".localized)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Button("key.unlock".localized) {
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
        }.navigationBarItems(trailing:
                                Button(action: {
            lang.currentLanguage = lang.currentLanguage.toggled
        }) {
            Text(lang.currentLanguage.toggled.flag)
            .font(.system(size: 24))}
        )
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
