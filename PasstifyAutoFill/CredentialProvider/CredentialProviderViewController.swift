//
//  CredentialProviderViewController.swift
//  Passtify
//
//  Created by Phan Hoang Long on 18/5/25.
//

import AuthenticationServices
import LocalAuthentication
import SwiftUI

final class CredentialProviderViewController: ASCredentialProviderViewController {
    
    private let viewModel = CredentialProviderViewModel()
    
    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
        viewModel.loadMatchedCredentials(for: serviceIdentifiers) { [weak self] in
            self?.showSwiftUI()
        }
    }
    
    private func showSwiftUI() {
        let view = CredentialRootView(
            credentials: viewModel.credentials,
            onSelect: { selected in
                let credential = ASPasswordCredential(user: selected.userName, password: selected.password)
                self.extensionContext.completeRequest(withSelectedCredential: credential)
            },
            onCancel: {
                self.extensionContext.cancelRequest(withError: NSError(
                    domain: ASExtensionErrorDomain,
                    code: ASExtensionError.userCanceled.rawValue
                ))
            }
        )
        
        let host = UIHostingController(rootView: view)
        addChild(host)
        host.view.frame = self.view.bounds
        self.view.addSubview(host.view)
        host.didMove(toParent: self)
    }
    
    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
        do {
            let encryptedData = try Data(contentsOf: FilePath.password)
            let decrypted = try CryptoManager.decrypt(encryptedData: encryptedData)
            let decoded: [PasswordItemModel] = try JSONDecoder().decode([PasswordItemModel].self, from: decrypted)

            guard let matched = decoded.first(where: {
                $0.userName == credentialIdentity.user &&
                $0.domainOrLabel == credentialIdentity.serviceIdentifier.identifier
            }) else {
                throw NSError(domain: "NoMatch", code: 404)
            }

            let credential = ASPasswordCredential(user: matched.userName, password: matched.password)
            extensionContext.completeRequest(withSelectedCredential: credential)

        } catch {
            extensionContext.cancelRequest(withError: NSError(
                domain: ASExtensionErrorDomain,
                code: ASExtensionError.failed.rawValue
            ))
        }

    }


}
