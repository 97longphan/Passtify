//
//  AppRootCoordinatorView.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import SwiftUI

struct AppRootCoordinatorView: View {
    @ObservedObject var coordinator: AppRootCoordinator
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var session: AppSession
    
    var body: some View {
        if session.isAuthenticated {
            homeView()
        } else {
            AuthenticationView(viewModel: coordinator.authenViewModel)
        }
    }
    
    @ViewBuilder
    private func homeView() -> some View {
        NavigationStack(path: $coordinator.path) {
            HomeView(viewModel: coordinator.homeViewModel)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .passwordList(let vm):
                        PasswordListView(viewModel: vm)
                    case .detailPassword(let vm):
                        DetailPasswordView(viewModel: vm)
                    case .deletedPasswordList(let vm):
                        DeletedPasswordListView(viewModel: vm)
                    case .deletedDetailPassword(let vm):
                        DetailDeletedPasswordView(viewModel: vm)
                    }
                }
        }
        .sheet(item: $coordinator.newPasswordViewModel) { vm in
            NewPasswordView(viewModel: vm)
        }
    }
}
