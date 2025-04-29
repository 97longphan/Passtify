//
//  AppRootCoordinator.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Foundation
import Swinject

@Observable
class AppRootCoordinator: ViewModel {
    private(set) var loginViewModel: LoginViewModel!
    private let resolver: Resolver
    
    let path = ObjectNavigationPath()
    
//    var profileViewModel: Profile
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.loginViewModel = self.resolver.resolved(LoginViewModel.self).setup(delegate: self)
    }
}

extension AppRootCoordinator: LoginViewModelDelegate {
    
}
