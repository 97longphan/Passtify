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

            Text("Không có mật khẩu đã xoá")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Các mật khẩu và mã khoá đã xoá sẽ có sẵn tại đây trong 30 ngày, trước khi bị xoá tự động.")
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
