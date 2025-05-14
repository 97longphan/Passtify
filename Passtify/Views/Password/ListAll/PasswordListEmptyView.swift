//
//  EmptyPasswordListView.swift
//  Passtify
//
//  Created by Phan Hoang Long on 9/5/25.
//

import SwiftUI

struct PasswordListEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "key")
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text("key.no_saved_passwords".localized)
                .font(.headline)
                .foregroundColor(.primary)

            Text("key.passwords_auto_fill_guide".localized)
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
