//
//  AppRootCoordinatorView.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import SwiftUI

struct AppRootCoordinatorView: View {
    @ObservedObject var coordinator: AppRootCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeView(viewModel: coordinator.homeViewModel)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .passwordList(let vm):
                        PasswordListView(viewModel: vm)
                    case .detailPassword(let vm):
                        DetailPasswordView(viewModel: vm)
                    }
                }
        }
        .sheet(item: $coordinator.newPasswordViewModel) { vm in
            NewPasswordView(viewModel: vm)
        }
    }
}
