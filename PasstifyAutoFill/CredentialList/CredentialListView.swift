//
//  CredentialListView.swift
//  Passtify
//
//  Created by Phan Hoang Long on 18/5/25.
//
import SwiftUI
import AuthenticationServices

struct CredentialListView: View {
    let credentials: [PasswordItemModel]
    let onSelect: (PasswordItemModel) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            List(credentials) { item in
                Button(action: { onSelect(item) }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.label).font(.headline)
                        Text(item.userName).font(.subheadline)
                        if let domain = item.domain {
                            Text(domain).font(.caption).foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Select Password")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
            }.safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 50)
            }
        }
    }
}
