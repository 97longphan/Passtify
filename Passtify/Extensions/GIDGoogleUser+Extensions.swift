//
//  GIDGoogleUser+Extensions.swift
//  Passtify
//
//  Created by LONGPHAN on 30/4/25.
//
import GoogleSignIn
import FirebaseAuth

extension GIDGoogleUser {
    func createGoogleAuthCredential() -> AuthCredential {
        return GoogleAuthProvider.credential(withIDToken: self.idToken?.tokenString ?? "",
                                             accessToken: self.accessToken.tokenString)
    }
}
