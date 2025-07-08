//
//  CardItemModel.swift
//  Passtify
//
//  Created by LONGPHAN on 8/7/25.
//
import Foundation

struct CardItemModel: Identifiable, Codable {
    var id: UUID = UUID()
    var bankType: BankType
    var cardNumber: String
    var balance: Double
    var expiryDate: String
    var cardHolderName: String
    var cvv: String
    var creationDate = Date()
    var cardType: CardType {
        CardType.from(cardNumber: cardNumber)
    }
    
    static var empty: CardItemModel {
        CardItemModel(
            bankType: .unknown,
            cardNumber: "",
            balance: 0,
            expiryDate: "",
            cardHolderName: "",
            cvv: ""
        )
    }
}

extension CardItemModel {
    func last4Digits() -> String {
        let trimmed = cardNumber.replacingOccurrences(of: " ", with: "")
        return String(trimmed.suffix(4))
    }
}

enum CardType: String {
    case visa = "Visa"
    case masterCard = "MasterCard"
    case unknown = "Unknown"
    
    static func from(cardNumber: String) -> CardType {
        let trimmed = cardNumber.replacingOccurrences(of: " ", with: "")
        
        if trimmed.hasPrefix("4") {
            return .visa
        } else if let first6 = Int(trimmed.prefix(6)),
                  (222100...272099).contains(first6) || (51...55).contains(Int(trimmed.prefix(2)) ?? -1) {
            return .masterCard
        } else {
            return .unknown
        }
    }
    
    var logoAssetName: String {
        switch self {
        case .visa:
            return "visa_logo"
        case .masterCard:
            return "mastercard_logo"
        case .unknown:
            return "unknown"
        }
    }
}

enum BankType: String, CaseIterable, Identifiable, Codable {
    case techcombank = "Techcombank"
    case vietcombank = "Vietcombank"
    case kbank = "Kbank"
    case hsbc = "HSBC"
    case unknown = "Unknown"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .techcombank: return "ic_logo_tcb"
        case .vietcombank: return "ic_logo_vcb"
        case .unknown: return "ic_logo_bank_unknown"
        case .kbank: return "ic_logo_kbank"
        case .hsbc: return "ic_logo_hsbc"
        }
    }
}
