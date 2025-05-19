//
//  PasswordItemModel.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import Foundation

struct PasswordItemModel: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var domainOrLabel: String
    var userName: String
    var password: String
    var creationDate = Date()
    var notes: String?
    
    static var empty: PasswordItemModel {
        PasswordItemModel(
            domainOrLabel: "",
            userName: "",
            password: "",
            notes: nil
        )
    }
}
