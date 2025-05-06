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

class NewPasswordViewModel: ViewModel {
    @Published var input = PasswordItemModel.empty
    
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
        passwordService.addPassword(input)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] _ in
                self?.delegate?.didCreatedNewPassword()
            }
            .store(in: &cancellables)
    }
    
    func isFormValid() -> Bool {
        !input.label.trimmingCharacters(in: .whitespaces).isEmpty &&
        !input.userName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !input.password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func bind() {}
}

