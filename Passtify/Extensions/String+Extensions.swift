//
//  String+Extensions.swift
//  Passtify
//
//  Created by Phan Hoang Long on 14/5/25.
//
import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

extension String {
    func formattedCardNumber() -> String {
        print("called \(self)")
        let cleaned = self.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        return stride(from: 0, to: cleaned.count, by: 4)
            .map {
                let start = cleaned.index(cleaned.startIndex, offsetBy: $0)
                let end = cleaned.index(start, offsetBy: 4, limitedBy: cleaned.endIndex) ?? cleaned.endIndex
                return String(cleaned[start..<end])
            }
            .joined(separator: " ")
    }

    func unformattedCardNumber() -> String {
        self.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
    }
}
