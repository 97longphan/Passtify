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
    var matchedCredentials: [PasswordItemModel] = []
    private var cancellables = Set<AnyCancellable>()
    private let passwordService: PasswordServiceProtocol
    
    init(passwordService: PasswordServiceProtocol = PasswordService()) {
        self.passwordService = passwordService
    }
    
    func loadMatchedCredentials(for serviceIdentifiers: [ASCredentialServiceIdentifier], completion: @escaping () -> Void) {
        passwordService.loadPasswords()
            .map { credentials in
                credentials
                    .sorted { $0.creationDate > $1.creationDate }
                    .filter { credential in
                        guard let domain = credential.domain else { return false }
                        return serviceIdentifiers.contains(where: { domain.contains($0.identifier) })
                    }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    print("❌ Error loading credentials: \(error)")
                }
            }, receiveValue: { [weak self] filtered in
                self?.matchedCredentials = filtered
                completion()
            })
            .store(in: &cancellables)
    }
}
