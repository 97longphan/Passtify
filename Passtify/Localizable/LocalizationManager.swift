//
//  LocalizationManager.swift
//  Passtify
//
//  Created by Phan Hoang Long on 14/5/25.
//
// MARK: - Step 1: Create LocalizationManager.swift
import Foundation
import Combine
import SwiftUI
enum AppLanguage: String, CaseIterable {
    case en = "en"
    case vi = "vi"
    
    var flag: String {
        switch self {
        case .en: return "🇺🇸"
        case .vi: return "🇻🇳"
        }
    }
    
    var displayName: String {
        switch self {
        case .en: return "English"
        case .vi: return "Tiếng Việt"
        }
    }
    
    var toggled: AppLanguage {
        return self == .en ? .vi : .en
    }
    
    static var defaultLanguage: AppLanguage {
        let code = Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? "en"
        return AppLanguage(rawValue: code) ?? .en
    }
}

final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            Bundle.setLanguage(currentLanguage.rawValue)
        }
    }
    
    private init() {
        if let saved = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first,
           let lang = AppLanguage(rawValue: saved) {
            currentLanguage = lang
        } else {
            currentLanguage = AppLanguage.defaultLanguage
        }
        Bundle.setLanguage(currentLanguage.rawValue)
    }
}
