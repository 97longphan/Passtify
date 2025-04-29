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
    var googleLoginSubject: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func setup(delegate: LoginViewModelDelegate) -> Self {
        self.delegate = delegate
        bind()
        return self
    }
    
    private func bind() {
        googleLoginSubject
            .sink { [weak self] in
                self?.authService.signInWithGoogle()
            }.store(in: &cancellables)
    }
    
}
