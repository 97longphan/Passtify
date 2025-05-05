//
//  PasswordItemModel.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import Foundation

struct PasswordItemModel: Identifiable, Codable {
    var id = UUID()
    var name: String
    var encryptedPassword: String
    var creationDate = Date()
    var notes: String?

    // Có thể thêm các thuộc tính khác nếu cần
}
