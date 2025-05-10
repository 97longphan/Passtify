//
//  ServiceAssembly.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Swinject

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FileServiceProtocol.self) { r in
            FileService()
        }.inObjectScope(.transient) // Luôn tạo mới mỗi lần resolve. Không giữ lại.
        
        container.register(PasswordServiceProtocol.self) { r in
            PasswordService()
        }.inObjectScope(.transient) // Luôn tạo mới mỗi lần resolve. Không giữ lại.
        
        container.register(AuthServiceProtocol.self) { r in
            AuthService()
        }.inObjectScope(.transient) // Luôn tạo mới mỗi lần resolve. Không giữ lại.
    }
}
