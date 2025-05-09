//
//  HomeCardItemView.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//
import SwiftUI

struct HomeListItemView: View {
    let item: HomeItemCategoryModel

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(item.type.iconBackgroundColor)
                    .frame(width: 44, height: 44)
                Image(systemName: item.type.iconName)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.type.title)
                    .font(.body)
                Text(item.type.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if item.type.isShowCount {
                Text("\(item.count)")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle())
    }
}
