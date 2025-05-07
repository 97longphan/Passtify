//
//  FirebaseService.swift
//  Passtify
//
//  Created by LONGPHAN on 29/4/25.
//

import Combine
import LocalAuthentication

protocol AuthServiceProtocol {
    func authenticateUser(completion: @escaping (Bool, LAError.Code?) -> Void)
}


final class AuthService: AuthServiceProtocol {
    
    func authenticateUser(completion: @escaping (Bool, LAError.Code?) -> Void) {
        let context = LAContext()
        let reason = "Xác thực để truy cập dữ liệu"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            if success {
                completion(true, nil)
            } else {
                let laErrorCode = (error as? LAError)?.code
                completion(false, laErrorCode)
            }
        }
    }
}



