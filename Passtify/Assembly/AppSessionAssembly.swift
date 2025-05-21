//
//  AppSessionAssembly.swift
//  Passtify
//
//  Created by Phan Hoang Long on 21/5/25.
//
import Swinject
class AppSessionAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppSession.self) { _ in
            AppSession()
        }.inObjectScope(.container) // Tạo một instance duy nhất trong toàn bộ container (singleton).
    }
}
