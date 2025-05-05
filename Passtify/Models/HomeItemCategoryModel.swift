//
//  HomeItemCategoryModel.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//
import Foundation
import SwiftUI

enum HomeItemCategoryType: CaseIterable, Identifiable {
    case password
    case passcodes
    case keys
    case wifi
    case security
    case deleted
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .password: return "Tất cả"
        case .passcodes: return "Mã khóa"
        case .keys: return "Mã"
        case .wifi: return "Wi-Fi"
        case .security: return "Bảo mật"
        case .deleted: return "Đã xóa"
        }
    }
    
    var iconName: String {
        switch self {
        case .password: return "key.fill"
        case .passcodes: return "lock.shield.fill"
        case .keys: return "key"
        case .wifi: return "wifi"
        case .security: return "checkmark.shield.fill"
        case .deleted: return "trash.fill"
        }
    }
    
    var iconBackgroundColor: Color {
        switch self {
        case .password: return .blue
        case .passcodes: return .green
        case .keys: return .yellow
        case .wifi: return .orange
        case .security: return .gray
        case .deleted: return .red
        }
    }
}

struct HomeItemCategoryModel: Identifiable {
    let id = UUID()
    let type: HomeItemCategoryType
    var count: Int
}
