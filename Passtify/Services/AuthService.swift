//
//  FirebaseService.swift
//  Passtify
//
//  Created by LONGPHAN on 29/4/25.
//

import GoogleSignIn
import Combine
import FirebaseCore
import FirebaseAuth

protocol AuthServiceProtocol {
    func signInWithGoogle() -> AnyPublisher<UserModel, SignInError>
}


final class AuthService: AuthServiceProtocol {
    private let googleService: GoogleServiceProtocol
    private let firebaseService: FirebaseServiceProtocol
    
    init(googleService: GoogleServiceProtocol,
         firebaseService: FirebaseServiceProtocol) {
        self.googleService = googleService
        self.firebaseService = firebaseService
    }
    
    func signInWithGoogle() -> AnyPublisher<UserModel, SignInError> {
        googleService.getGoogleUser()
            .map { $0.createGoogleAuthCredential() }
            .flatMap { [firebaseService] credential in
                firebaseService.signIn(with: credential)
            }
            .eraseToAnyPublisher()
    }
    
}

