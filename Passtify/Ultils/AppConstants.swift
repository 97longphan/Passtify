//
//  AppConstants.swift
//  Passtify
//
//  Created by Phan Hoang Long on 17/5/25.
//

import Foundation

enum Constants {
    enum FileName {
        static let password = "passwords.enc"
        static let deletedPassword = "deletepasswords.enc"
        static let zipBackup = "PasswordsBackup.zip"
        static let card = "card.enc"
    }
    
    enum TempDirectory {
        static let importFolder = "ImportTemp"
    }
    
    enum AppGroup {
        static let id = "group.dev.longphan.passtify"
    }
    
    enum AppPassword {
        
    }
    
    enum AppCard {
        static let validCardNumberLength = 16
        static let validCVVLength = 3
        static let validExpiryLength = 5
    }
}

enum FilePath {
    private static let containerURL: URL = {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.AppGroup.id) else {
            fatalError("❌ App Group not found: \(Constants.AppGroup.id)")
        }
        return url
    }()

    static var password: URL {
        containerURL.appendingPathComponent(Constants.FileName.password)
    }

    static var deletedPassword: URL {
        containerURL.appendingPathComponent(Constants.FileName.deletedPassword)
    }
    
    static var card: URL {
        containerURL.appendingPathComponent(Constants.FileName.card)
    }
}
