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
            credentials: viewModel.matchedCredentials,
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
}
