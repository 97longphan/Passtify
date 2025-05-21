//
//  SignInError.swift
//  Passtify
//
//  Created by LONGPHAN on 30/4/25.
//
import Foundation
import LocalAuthentication

enum AuthenError: Error {
    case unknown
    case authenticationFailed
    case userFallback
    case systemCancel
    case passcodeNotSet
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case appCancel
    case invalidContext
    case notInteractive

    var msg: String {
        switch self {
        case .authenticationFailed:
            return "authen.authentication_failed".localized
        case .userFallback:
            return "authen.user_fallback".localized
        case .systemCancel:
            return "authen.system_cancel".localized
        case .passcodeNotSet:
            return "authen.passcode_not_set".localized
        case .biometryNotAvailable:
            return "authen.biometry_not_available".localized
        case .biometryNotEnrolled:
            return "authen.biometry_not_enrolled".localized
        case .biometryLockout:
            return "authen.biometry_lockout".localized
        case .appCancel:
            return "authen.app_cancel".localized
        case .invalidContext:
            return "authen.invalid_context".localized
        case .notInteractive:
            return "authen.not_interactive".localized
        case .unknown:
            return "authen.unknown".localized
        }
    }

    static func from(_ code: LAError.Code?) -> AuthenError {
        switch code {
        case .authenticationFailed: return .authenticationFailed
        case .userFallback: return .userFallback
        case .systemCancel: return .systemCancel
        case .passcodeNotSet: return .passcodeNotSet
        case .biometryNotAvailable: return .biometryNotAvailable
        case .biometryNotEnrolled: return .biometryNotEnrolled
        case .biometryLockout: return .biometryLockout
        case .appCancel: return .appCancel
        case .invalidContext: return .invalidContext
        case .notInteractive: return .notInteractive
        default: return .unknown
        }
    }
}
