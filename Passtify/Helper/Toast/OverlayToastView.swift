//
//  OverlayToastView.swift
//  Passtify
//
//  Created by Phan Hoang Long on 9/5/25.
//

import SwiftUI
enum ToastType {
    case normal
    case error
    
    var backgroundColor: Color {
        switch self {
        case .normal: return Color.green.opacity(0.85)
        case .error: return Color.red.opacity(0.85)
        }
    }
    
    var icon: Image {
        switch self {
        case .normal: return Image(systemName: "checkmark.circle.fill")
        case .error: return Image(systemName: "xmark.octagon.fill")
        }
    }
}

struct OverlayToastView: View {
    let message: String
    let type: ToastType
    
    var body: some View {
        HStack(spacing: 10) {
            type.icon
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold))
            
            Text(message)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(type.backgroundColor)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
        .padding(.bottom, 40)
        .transition(.asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .opacity
        ))
    }
}



