//
//  CredentialProviderViewModel.swift
//  Passtify
//
//  Created by Phan Hoang Long on 18/5/25.
//

import Combine
import Foundation
import AuthenticationServices

final class CredentialProviderViewModel {
    var credentials: [PasswordItemModel] = []
    private var cancellables = Set<AnyCancellable>()
    private let passwordService: PasswordServiceProtocol
    
    init(passwordService: PasswordServiceProtocol = PasswordService()) {
        self.passwordService = passwordService
    }
    
    func loadMatchedCredentials(for serviceIdentifiers: [ASCredentialServiceIdentifier], completion: @escaping () -> Void) {
        passwordService.loadPasswords()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    print("❌ Error loading credentials: \(error)")
                }
            }, receiveValue: { [weak self] data in
                self?.credentials = data
                completion()
            })
            .store(in: &cancellables)
    }
}
