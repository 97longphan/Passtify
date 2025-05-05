//
//  AppRootCoordinator.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Foundation
import Swinject
import FirebaseAuth

@Observable
class AppRootCoordinator: ViewModel {
    private(set) var loginViewModel: LoginViewModel!
    private(set) var homeViewModel: HomeViewModel!
    private let resolver: Resolver
    private let authService: AuthServiceProtocol
    let path = ObjectNavigationPath()
    var isLoggedIn: Bool = false
    var newPasswordViewModel: NewPasswordViewModel?
    private var passwordListViewModel: PasswordListViewModel?
    
    init(resolver: Resolver, authService: AuthServiceProtocol) {
        self.authService = authService
        self.resolver = resolver
        self.loginViewModel = self.resolver.resolved(LoginViewModel.self).setup(delegate: self)
        self.homeViewModel = self.resolver.resolved(HomeViewModel.self).setup(delegate: self)
        checkUserLogin()
    }
    
    func checkUserLogin() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = user != nil
        }
    }
}

extension AppRootCoordinator: LoginViewModelDelegate {
    
}

extension AppRootCoordinator: HomeViewModelDelegate {
    func didPressPassword() {
        passwordListViewModel = resolver.resolved(PasswordListViewModel.self).setup(delegate: self)
        path.append(passwordListViewModel!)
    }
}

extension AppRootCoordinator: PasswordListViewModelDelegate {
    func didCreateNewPassword() {
        newPasswordViewModel = resolver.resolved(NewPasswordViewModel.self).setup(delegate: self)
    }
}

extension AppRootCoordinator: NewPasswordViewModelDelegate {
    func didCreatedNewPassword() {
        newPasswordViewModel = nil
        passwordListViewModel?.loadPasswords()
    }
    
    func dismissNewPassword() {
        newPasswordViewModel = nil
    }
    
}
