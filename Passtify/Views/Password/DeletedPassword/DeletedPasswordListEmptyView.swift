//
//  EmptyRecentlyDeletedView.swift
//  Passtify
//
//  Created by Phan Hoang Long on 9/5/25.
//

import SwiftUI

struct DeletedPasswordListEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "trash")
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text("key.no_deleted_passwords".localized)
                .font(.headline)
                .foregroundColor(.primary)

            Text("key.deleted_passwords_guide".localized)
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
