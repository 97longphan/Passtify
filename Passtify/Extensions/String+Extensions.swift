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
