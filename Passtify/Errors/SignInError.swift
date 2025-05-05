//
//  SignInError.swift
//  Passtify
//
//  Created by LONGPHAN on 30/4/25.
//
import Foundation

enum SignInError: Error {
    case missingPresentingVC
    case signInFailed(Error)
    case firebaseAuthFailed(Error)
    case unknown
}
