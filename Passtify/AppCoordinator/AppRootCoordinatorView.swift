//
//  AppRootCoordinatorView.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import SwiftUI

struct AppRootCoordinatorView: View {
    @Bindable var coordinator: AppRootCoordinator
    @State private var newPasswordViewModel: NewPasswordViewModel?
    
    var body: some View {
        ObjectNavigationStack(path: coordinator.path) {
            if coordinator.isLoggedIn {
                AnyView(homeView())
            } else {
                AnyView(LoginView(viewModel: coordinator.loginViewModel))
            }
        }
        .onChange(of: self.coordinator.newPasswordViewModel, initial: true) { _, value in
            self.newPasswordViewModel = value
        }
    }
    
    private func homeView() -> some View {
        HomeView(viewModel: coordinator.homeViewModel)
            .navigationDestination(for: PasswordListViewModel.self, destination: { viewModel in
                passwordListView(viewModel: viewModel)})
            .onAppear {
                print("long dev \(coordinator.path.count())")
            }
    }
    
    private func passwordListView(viewModel: PasswordListViewModel) -> some View {
        PasswordListView(viewModel: viewModel)
            .sheet(item: $newPasswordViewModel) { viewModel in
                NewPasswordView(viewModel: viewModel)
            }
    }
}
