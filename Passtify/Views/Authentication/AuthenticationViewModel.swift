//
//  AuthenticationViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 7/5/25.
//

import Foundation
import Combine

final class AuthenticationViewModel: ObservableObject {
    private let authService: AuthServiceProtocol
    private(set) var didCancelLastAttempt = false
    
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func authenticate(completion: @escaping (Bool) -> Void = { _ in }) {
        completion(true)
//        authService.authenticateUser { [weak self] success, errorCode in
//            DispatchQueue.main.async {
//                if success {
//                    self?.didCancelLastAttempt = false
//                } else {
//                    if errorCode == .userCancel || errorCode == .systemCancel {
//                        self?.didCancelLastAttempt = true
//                    }
//                }
//                completion(success)
//            }
//        }
    }
}
