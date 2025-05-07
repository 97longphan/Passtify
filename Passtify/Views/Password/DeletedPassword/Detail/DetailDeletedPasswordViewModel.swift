//
//  DetailDeletedPasswordViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 5/5/25.
//
import Combine

protocol DetailDeletedPasswordViewModelDelegate: AnyObject {
    func didPermanentlyDeletePassword()
    func didRecoverPassword()
}

class DetailDeletedPasswordViewModel: ViewModel {
    private var delegate: DetailDeletedPasswordViewModelDelegate?
    private let passwordService: PasswordServiceProtocol
    @Published var passwordItem: PasswordItemModel
    private var cancellables = Set<AnyCancellable>()
    
    init(passwordItem: PasswordItemModel, passwordService: PasswordServiceProtocol) {
        self.passwordItem = passwordItem
        self.passwordService = passwordService
    }
    
    func setup(delegate: DetailDeletedPasswordViewModelDelegate) -> Self {
        self.delegate = delegate
        bind()
        return self
    }
    
    private func bind() {
        // Optional Combine bindings here
    }
    
    func recoverPassword() {
        passwordService.recoverDeletedPassword(passwordItem)
            .sink { _ in
            } receiveValue: { [weak self] in
                self?.delegate?.didRecoverPassword()
            }.store(in: &cancellables)
    }
    
    func permanentlyDeletePassword() {
        passwordService.permanentlyDeletePassword(passwordItem)
            .sink { _ in
            } receiveValue: { [weak self] in
                self?.delegate?.didPermanentlyDeletePassword()
            }.store(in: &cancellables)
    }
}
