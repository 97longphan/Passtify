//
//  CoordinatorAssembly.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Swinject
class CoordinatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppRootCoordinator.self) { r in
            AppRootCoordinator(resolver: r)
        }.inObjectScope(.container) // Tạo một instance duy nhất trong toàn bộ container (singleton).
    }
}
