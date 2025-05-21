//
//  FirebaseService.swift
//  Passtify
//
//  Created by LONGPHAN on 29/4/25.
//

import LocalAuthentication
import Combine

protocol AuthServiceProtocol {
    func authenticateUser() -> AnyPublisher<Void, AuthenError>
}


final class AuthService: AuthServiceProtocol {
    func authenticateUser() -> AnyPublisher<Void, AuthenError> {
            Future { promise in
                let context = LAContext()
                let reason = "Xác thực để truy cập dữ liệu"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                    if success {
                        promise(.success(()))
                    } else {
                        let code = (error as? LAError)?.code
                        promise(.failure(AuthenError.from(code)))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
}
