//
//  CredentialProviderViewModel.swift
//  Passtify
//
//  Created by Phan Hoang Long on 18/5/25.
//

import Combine
import Foundation
import AuthenticationServices

final class CredentialProviderViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let passwordService: PasswordServiceProtocol
    @Published var credentials: [PasswordItemModel] = []
    var onDismissNewPassword: (() -> Void)?
    var onDidCreatedNewPassword: (() -> Void)?
    var serviceIdentifiers: [ASCredentialServiceIdentifier] = []
    
    init(passwordService: PasswordServiceProtocol = PasswordService()) {
        self.passwordService = passwordService
    }
    
    func loadMatchedCredentials(completion: (() -> Void)? = nil) {
        passwordService.loadPasswords()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    print("❌ Error loading credentials: \(error)")
                }
            }, receiveValue: { [weak self] data in
                self?.credentials = data
                completion?()
            })
            .store(in: &cancellables)
    }
    
    func createNewPassword() -> NewPasswordView {
        let newVM = NewPasswordViewModel(passwordService: passwordService)
        var input = PasswordItemModel.empty
        input.domainOrLabel = serviceIdentifiers.first?.identifier.toDomain ?? ""
        newVM.input = input
        _ = newVM.setup(delegate: self)
        return NewPasswordView(viewModel: newVM)
    }
}

extension CredentialProviderViewModel: NewPasswordViewModelDelegate {
    func dismissNewPassword() {
        onDismissNewPassword?()
    }
    
    func didCreatedNewPassword() {
        onDidCreatedNewPassword?()
    }
}

extension String {
    var toDomain: String? {
        var url = URL(string: self)
        return url?.host()
    }
}
