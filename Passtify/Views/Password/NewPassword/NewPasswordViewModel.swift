//
//  NewPasswordViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import Combine
import Foundation
protocol NewPasswordViewModelDelegate: AnyObject {
    func dismissNewPassword()
    func didCreatedNewPassword()
}

@Observable
class NewPasswordViewModel: ViewModel {
    private weak var delegate: NewPasswordViewModelDelegate?
    private let passwordService: PasswordServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(passwordService: PasswordServiceProtocol) {
        self.passwordService = passwordService
    }
    
    func setup(delegate: NewPasswordViewModelDelegate) -> Self {
        self.delegate = delegate
        bind()
        return self
    }
    
    func onDissmissNewPassword() {
        delegate?.dismissNewPassword()
    }
    
    func onSaveNewPassword() {
        passwordService.addPassword(PasswordItemModel(name: "long", encryptedPassword: "123"))
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] _ in
                self?.delegate?.didCreatedNewPassword()
            }.store(in: &cancellables)

    }
    
    private func bind() {
    }
}
