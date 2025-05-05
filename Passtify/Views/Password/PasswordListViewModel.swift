//
//  PasswordListViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import Combine
import Foundation
protocol PasswordListViewModelDelegate: AnyObject {
    func didCreateNewPassword()
}

@Observable
class PasswordListViewModel: ViewModel {
    private weak var delegate: PasswordListViewModelDelegate?
    private let passwordService: PasswordServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    var passwordList: [PasswordItemModel] = []
    
    init(passwordService: PasswordServiceProtocol) {
        self.passwordService = passwordService
        loadPasswords()
    }
    
    func setup(delegate: PasswordListViewModelDelegate) -> Self {
        self.delegate = delegate
        bind()
        return self
    }
    
    private func bind() {
    }
    
    func onActionCreateNewPassword() {
        delegate?.didCreateNewPassword()
    }
    
    func loadPasswords() {
        passwordService.loadPasswords()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] in
                self?.passwordList = $0
            }.store(in: &cancellables)
    }
}
