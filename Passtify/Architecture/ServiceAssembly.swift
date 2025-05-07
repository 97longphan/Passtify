//
//  ServiceAssembly.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Swinject

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PasswordServiceProtocol.self) { r in
            PasswordService()
        }.inObjectScope(.transient) // Luôn tạo mới mỗi lần resolve. Không giữ lại.
        
        
        container.register(FirebaseServiceProtocol.self) { r in
            FirebaseService()
        }.inObjectScope(.transient) // Luôn tạo mới mỗi lần resolve. Không giữ lại.
        
        container.register(GoogleServiceProtocol.self) { r in
            GoogleService()
        }.inObjectScope(.transient) // Luôn tạo mới mỗi lần resolve. Không giữ lại.
        
        container.register(AuthServiceProtocol.self) { r in
            AuthService()
        }.inObjectScope(.transient) // Luôn tạo mới mỗi lần resolve. Không giữ lại.
    }
}
