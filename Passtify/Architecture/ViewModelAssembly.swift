//
//  ViewModelAssembly.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Swinject

class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DetailPasswordViewModel.self) { (r, item: PasswordItemModel) in
            DetailPasswordViewModel(passwordItem: item, passwordService: r.resolved(PasswordServiceProtocol.self))
        }.inObjectScope(.transient)
        
        container.register(LoginViewModel.self) { r in
            LoginViewModel(authService: r.resolved(AuthServiceProtocol.self))
        }.inObjectScope(.transient) // Luôn tạo mới mỗi lần resolve. Không giữ lại.
        
        container.register(HomeViewModel.self) { _ in
            HomeViewModel()
        }.inObjectScope(.transient)
        
        container.register(PasswordListViewModel.self) { r in
            PasswordListViewModel(passwordService: r.resolved(PasswordServiceProtocol.self))
        }.inObjectScope(.transient)
        
        container.register(NewPasswordViewModel.self) { r in
            NewPasswordViewModel(passwordService: r.resolved(PasswordServiceProtocol.self))
        }.inObjectScope(.transient)
    }
}
