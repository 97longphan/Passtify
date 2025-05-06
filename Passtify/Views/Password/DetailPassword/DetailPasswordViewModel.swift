//
//  DetailPasswordViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 5/5/25.
//
import Combine

protocol DetailPasswordViewModelDelegate: AnyObject {
    func didDeletedPassword()
}

class DetailPasswordViewModel: ViewModel {
    private var delegate: DetailPasswordViewModelDelegate?
    private let passwordService: PasswordServiceProtocol
    @Published var passwordItem: PasswordItemModel
    private var cancellables = Set<AnyCancellable>()
    
    init(passwordItem: PasswordItemModel, passwordService: PasswordServiceProtocol) {
        self.passwordItem = passwordItem
        self.passwordService = passwordService
    }
    
    func setup(delegate: DetailPasswordViewModelDelegate) -> Self {
        self.delegate = delegate
        bind()
        return self
    }
    
    private func bind() {
        // Optional Combine bindings here
    }
    
    func updateItem(newItem: PasswordItemModel) {
        if newItem != passwordItem {
            passwordService.updatePassword(newItem)
                .sink { _ in
                } receiveValue: { [weak self] in
                    self?.passwordItem = newItem
                }.store(in: &cancellables)
        }
    }
    
    func deleteItem() {
        passwordService.deletePassword(passwordItem)
            .sink { _ in
            } receiveValue: { [weak self] in
                self?.delegate?.didDeletedPassword()
            }.store(in: &cancellables)

    }
}
