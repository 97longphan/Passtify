//
//  ViewModelAssembly.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Swinject

class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoginViewModel.self) { r in
            LoginViewModel(authService: r.resolved(AuthServiceProtocol.self))
        }.inObjectScope(.transient) // Luôn tạo mới mỗi lần resolve. Không giữ lại.
    }
}
