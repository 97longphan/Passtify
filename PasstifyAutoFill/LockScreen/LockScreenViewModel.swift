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
        case failure
    }
    
    @Published var result: AuthResult?
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func authenticate() {
        authService.authenticateUser()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure:
                    self?.result = .failure
                default:
                    break
                }
            } receiveValue: { [weak self] in
                self?.result = .success
            }
            .store(in: &cancellables)
    }
}
