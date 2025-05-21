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
    private let session: AppSession
    private var cancellables = Set<AnyCancellable>()
    @Published var errorMessage: String?
    
    init(authService: AuthServiceProtocol,
         session: AppSession) {
        self.authService = authService
        self.session = session
    }
    
    func authenticate() {
    #if targetEnvironment(simulator)
        session.isAuthenticated = true
    #else
        authService.authenticateUser()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.msg
                default:
                    break
                }
            } receiveValue: { [weak self] in
                self?.session.isAuthenticated = true
            }
            .store(in: &cancellables)
    #endif
    }
}
