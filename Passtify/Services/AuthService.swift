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
    func signInWithGoogle()
}


final class AuthService: AuthServiceProtocol {
    func signInWithGoogle() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Không tìm thấy Client ID của Firebase.")
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let rootViewController = UIApplication.rootViewController() else {
            print("Không thể lấy được ViewController để trình bày.")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, anyerror in
            print(result?.user)
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print("Không nhận được ID token từ Google (đã bỏ qua).")
                return
            }
            
            let authProvider = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: authProvider) { result, error in
                print(result)
                
                print(error)
            }
            
        }
    }
    
}

