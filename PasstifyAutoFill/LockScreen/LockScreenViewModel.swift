//
//  LockScreenViewModel.swift
//  Passtify
//
//  Created by Phan Hoang Long on 18/5/25.
//

import Foundation
import Combine
import LocalAuthentication

final class LockScreenViewModel: ObservableObject {
    enum AuthResult: Equatable {
        case success
        case failure(LAError.Code?)
    }
    
    @Published var result: AuthResult?
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func authenticate() {
        authService.authenticateUser { [weak self] success, errorCode in
            DispatchQueue.main.async {
                self?.result = success ? .success : .failure(errorCode)
            }
        }
    }
}
