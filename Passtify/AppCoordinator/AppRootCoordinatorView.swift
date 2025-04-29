//
//  AppRootCoordinatorView.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import SwiftUI

struct AppRootCoordinatorView: View {
    @Bindable var coordinator: AppRootCoordinator
    
    var body: some View {
        ObjectNavigationStack(path: coordinator.path) {
            LoginView(viewModel: coordinator.loginViewModel)
            
//            LandmarkListView(viewModel: coordinator.categoryHomeViewModel)
//            .navigationDestination(for: LandmarkDetailViewModel.self) { viewModel in
//                LandmarkDetailView(viewModel: viewModel)
//            }
        }
    }
}
