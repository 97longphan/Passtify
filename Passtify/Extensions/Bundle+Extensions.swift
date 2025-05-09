//
//  Bundle+Extensions.swift
//  Passtify
//
//  Created by Phan Hoang Long on 10/5/25.
//
import Foundation

extension Bundle {
    var appVersionDisplay: String {
        let version = infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }
}
