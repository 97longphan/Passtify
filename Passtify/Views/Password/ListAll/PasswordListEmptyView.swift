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

            Text("Không có mật khẩu đã lưu")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Mật khẩu được lưu tự động khi đăng nhập vào các trang web và ứng dụng.")
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
