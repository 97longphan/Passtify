//
//  CardListEmptyView.swift
//  Passtify
//
//  Created by LONGPHAN on 8/7/25.
//
import SwiftUI

struct CardListEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "creditcard")
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text("key.no_saved_cards".localized) // Đổi key
                .font(.headline)
                .foregroundColor(.primary)

            Text("key.cards_auto_fill_guide".localized) // Đổi key
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.clear))
    }
}
