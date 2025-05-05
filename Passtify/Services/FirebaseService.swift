//
//  FirebaseService.swift
//  Passtify
//
//  Created by LONGPHAN on 30/4/25.
//
import Foundation
import Combine
import FirebaseAuth

protocol FirebaseServiceProtocol {
    func signIn(with credential: AuthCredential) -> AnyPublisher<UserModel, SignInError>
}

final class FirebaseService: FirebaseServiceProtocol {
    func signIn(with credential: AuthCredential) -> AnyPublisher<UserModel, SignInError> {
        Future<UserModel, SignInError> { promise in
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    promise(.failure(.firebaseAuthFailed(error)))
                } else if let result = result {
                    let user = result.user
                    let userData = result.user.initUserModel()
                    promise(.success(userData))
                }else {
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
