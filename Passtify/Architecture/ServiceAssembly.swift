//
//  ServiceAssembly.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Swinject

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthServiceProtocol.self) { _ in
            AuthService()
        }.inObjectScope(.transient) // Luôn tạo mới mỗi lần resolve. Không giữ lại.
    }
}
