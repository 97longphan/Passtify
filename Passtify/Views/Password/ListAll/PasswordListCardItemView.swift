//
//  PasswordCardItemView.swift
//  Passtify
//
//  Created by Phan Hoang Long on 9/5/25.
//
import SwiftUI

struct PasswordListCardItemView: View {
    let passwordItem: PasswordItemModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: 44, height: 44)
                    
                    Text(passwordItem.domainOrLabel.prefix(1).uppercased())
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(passwordItem.domainOrLabel)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    if !passwordItem.userName.isEmpty {
                        Text(passwordItem.userName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            .padding(.horizontal)
            .padding(.vertical, 6) // ✅ khoảng cách giữa các card
        }
        .buttonStyle(PlainButtonStyle())
    }
}
