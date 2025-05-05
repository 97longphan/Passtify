//
//  FirebaseUser+Extensions.swift
//  Passtify
//
//  Created by LONGPHAN on 30/4/25.
//
import FirebaseAuth

extension User {
    func initUserModel() -> UserModel {
        return UserModel(id: self.uid,
                         name: self.displayName,
                         email: self.email)
    }
}
