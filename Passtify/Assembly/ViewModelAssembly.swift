//
//  ViewModelAssembly.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Swinject

class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthenticationViewModel.self) { r in
            AuthenticationViewModel(authService: r.resolved(AuthServiceProtocol.self), session: r.resolved(AppSession.self))
        }.inObjectScope(.transient) // Luôn tạo mới mỗi lần resolve. Không giữ lại.
        
        
        container.register(DetailDeletedPasswordViewModel.self) { (r, item: PasswordItemModel) in
            DetailDeletedPasswordViewModel(passwordItem: item, passwordService: r.resolved(PasswordServiceProtocol.self))
        }.inObjectScope(.transient)
        
        container.register(DeletedPasswordListViewModel.self) { r in
            DeletedPasswordListViewModel(passwordService: r.resolved(PasswordServiceProtocol.self))
        }.inObjectScope(.transient)
        
        container.register(DetailPasswordViewModel.self) { (r, item: PasswordItemModel) in
            DetailPasswordViewModel(passwordItem: item, passwordService: r.resolved(PasswordServiceProtocol.self))
        }.inObjectScope(.transient)
        
        container.register(HomeViewModel.self) { r in
            HomeViewModel(passwordService: r.resolved(PasswordServiceProtocol.self), fileService: r.resolved(FileServiceProtocol.self))
        }.inObjectScope(.transient)
        
        container.register(PasswordListViewModel.self) { r in
            PasswordListViewModel(passwordService: r.resolved(PasswordServiceProtocol.self))
        }.inObjectScope(.transient)
        
        container.register(NewPasswordViewModel.self) { r in
            NewPasswordViewModel(passwordService: r.resolved(PasswordServiceProtocol.self))
        }.inObjectScope(.transient)
    }
}
