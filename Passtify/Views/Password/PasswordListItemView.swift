//
//  PasswordListItemView.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import SwiftUI

struct PasswordListItemView: View {
    let passwordItem: PasswordItemModel
    
    var body: some View {
        HStack {
            // Hình tròn chứa chữ cái đầu tiên
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3)) // Màu xám nhạt
                    .frame(width: 40, height: 40)
                Text(passwordItem.domainOrLabel.prefix(1).uppercased())
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            VStack(alignment: .leading) {
                Text(passwordItem.domainOrLabel)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(passwordItem.userName) // Hoặc một đoạn mô tả khác
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 8) // Khoảng cách giữa hình tròn và text
            
            Spacer() // Đẩy các phần tử bên phải về cuối
            
            // Icon dấu chấm than và mũi tên
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
        .padding(12)
        .foregroundStyle(.primary)
    }
}

#Preview {
    PasswordListItemView(passwordItem: PasswordItemModel.init(domainOrLabel: "", userName: "", password: ""))
}
