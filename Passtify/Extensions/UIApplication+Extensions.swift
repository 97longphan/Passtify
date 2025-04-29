//
//  UIApplication+Extensions.swift
//  Passtify
//
//  Created by LONGPHAN on 30/4/25.
//
import UIKit

extension UIApplication {
    static func rootViewController() -> UIViewController? {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .first?
                .rootViewController
        } else {
            return UIApplication.shared.windows.first?.rootViewController
        }
    }
}

