//
//  HomeItemCategoryModel.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//
import Foundation
import SwiftUI

struct HomeItemCategoryModel: Identifiable {
    let id = UUID()
    let type: HomeItemCategoryType
    var count: Int
}

enum HomeItemCategoryGroup {
    case password
    case data
    case card
}

enum HomeItemCategoryType: CaseIterable, Identifiable {
    case password
    case card
    case deleted
    case importData
    case exportData

    var id: Self { self }

    var title: String {
        switch self {
        case .password: return "key.password".localized
        case .deleted: return "key.title_deleted".localized
        case .importData: return "key.title_import".localized
        case .exportData: return "key.title_export".localized
        case .card: return "key.title_card".localized
        }
    }

    var subtitle: String {
        switch self {
        case .password: return "key.subtitle_password".localized
        case .deleted: return "key.subtitle_deleted".localized
        case .importData: return "key.subtitle_import".localized
        case .exportData: return "key.subtitle_export".localized
        case .card: return "key.subtitle_card".localized
        }
    }

    var iconName: String {
        switch self {
        case .password: return "key.fill"
        case .deleted: return "trash.fill"
        case .importData: return "square.and.arrow.down.fill"
        case .exportData: return "square.and.arrow.up.fill"
        case .card: return "creditcard"

        }
    }

    var iconBackgroundColor: Color {
        switch self {
        case .password: return .blue
        case .deleted: return .red
        case .importData: return .green
        case .exportData: return .orange
        case .card: return .pink
        }
    }

    var isShowCount: Bool {
        switch self {
        case .password, .deleted, .card: return true
        default: return false
        }
    }

    var group: HomeItemCategoryGroup {
        switch self {
        case .password, .deleted: return .password
        case .importData, .exportData: return .data
        case .card: return .card
        }
    }
}

