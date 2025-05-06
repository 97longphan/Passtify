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
    func didSelectItem(item: PasswordItemModel)
}

class PasswordListViewModel: ViewModel {
    private weak var delegate: PasswordListViewModelDelegate?
    private let passwordService: PasswordServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var passwordList: [PasswordItemModel] = []
    
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
        // Optional Combine bindings here
    }

    func onActionCreateNewPassword() {
        delegate?.didCreateNewPassword()
    }
    
    func onActionSelectItem(item: PasswordItemModel) {
        delegate?.didSelectItem(item: item)
    }

    func loadPasswords() {
        passwordService.loadPasswords()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] passwords in
                self?.passwordList = passwords
            }
            .store(in: &cancellables)
    }
}

