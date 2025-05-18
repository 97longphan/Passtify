//
//  PasswordItemModel.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import Foundation

struct PasswordItemModel: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var label: String
    var userName: String
    var password: String
    var creationDate = Date()
    var notes: String?
    var domain: String?
    
    static var empty: PasswordItemModel {
        PasswordItemModel(
            label: "",
            userName: "",
            password: "",
            notes: nil,
            domain: nil
        )
    }
}
