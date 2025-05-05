//
//  GoogleService.swift
//  Passtify
//
//  Created by LONGPHAN on 30/4/25.
//

import Foundation
import GoogleSignIn
import Combine

protocol GoogleServiceProtocol {
    func getGoogleUser() -> AnyPublisher<GIDGoogleUser, SignInError>
}

final class GoogleService: GoogleServiceProtocol {
    func getGoogleUser() -> AnyPublisher<GIDGoogleUser, SignInError> {
        return Future<GIDGoogleUser, SignInError> { promise in
            guard let presentingVC = UIApplication.rootViewController() else {
                promise(.failure(.missingPresentingVC))
                return
            }
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { user, error in
                if let error = error {
                    promise(.failure(.signInFailed(error)))
                } else if let user = user {
                    promise(.success(user.user))
                } else {
                    promise(.failure(SignInError.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
