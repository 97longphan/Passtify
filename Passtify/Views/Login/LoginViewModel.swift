//
//  LoginViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 29/4/25.
//

import Combine
import Foundation

protocol LoginViewModelDelegate: AnyObject {}

@Observable
class LoginViewModel: ViewModel {
    private let authService: AuthServiceProtocol
    private weak var delegate: LoginViewModelDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func setup(delegate: LoginViewModelDelegate) -> Self {
        self.delegate = delegate
        bind()
        return self
    }
    
    private func bind() {
    }
    
    func signInWithGoogle() {
        authService.signInWithGoogle()
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] user in
                print("login success \(user)")
            }
            .store(in: &cancellables)
        
    }
    
}
