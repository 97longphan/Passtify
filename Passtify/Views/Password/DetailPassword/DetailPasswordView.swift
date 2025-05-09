//
//  DetailPasswordView.swift
//  Passtify
//
//  Created by LONGPHAN on 5/5/25.
//

import SwiftUI

struct DetailPasswordView: View {
    @ObservedObject var viewModel: DetailPasswordViewModel

    @State private var showCopiedToast = false
    @State private var copiedTextLabel = ""
    @State private var editing = false
    @State private var tempItem: PasswordItemModel = .empty
    @State private var showActionSheetDelete = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if editing {
                    EditableHeaderCard()
                    EditableInfoCard()
                } else {
                    HeaderCard()
                    InfoCard()
                }

                if editing {
                    DeleteButtonSection()
                }

                Spacer(minLength: 32)
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Chi tiết mật khẩu")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(editing)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if editing {
                    Button("Huỷ") {
                        editing = false
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(editing ? "Xong" : "Sửa") {
                    if editing {
                        viewModel.updateItem(newItem: tempItem)
                    } else {
                        tempItem = viewModel.passwordItem
                    }
                    editing.toggle()
                }
            }
        }
        .overlay(toastOverlay, alignment: .bottom)
    }

    private func HeaderCard() -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: 48, height: 48)
                .overlay(Text(viewModel.passwordItem.label.prefix(1).uppercased())
                    .font(.title2).bold())

            VStack(alignment: .leading) {
                Text(viewModel.passwordItem.label)
                    .font(.title3).bold()
                Text("Sửa đổi: \(formattedDate(viewModel.passwordItem.creationDate))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
    }

    private func InfoCard() -> some View {
        VStack(spacing: 12) {
            InfoRow(title: "Tên người dùng", value: viewModel.passwordItem.userName) {
                copyToClipboard(viewModel.passwordItem.userName, label: "tên người dùng")
            }
            InfoRow(title: "Mật khẩu", value: "••••••••") {
                copyToClipboard(viewModel.passwordItem.password, label: "mật khẩu")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
    }

    private func EditableHeaderCard() -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: 48, height: 48)
                .overlay(Text(tempItem.label.prefix(1).uppercased())
                    .font(.title2).bold())

            VStack(alignment: .leading) {
                TextField("Tên", text: $tempItem.label)
                    .font(.title3).bold()
                Text("Sửa đổi: \(formattedDate(viewModel.passwordItem.creationDate))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
    }

    private func EditableInfoCard() -> some View {
        VStack(spacing: 12) {
            EditableRow(title: "Tên người dùng", text: $tempItem.userName)
            EditableRow(title: "Mật khẩu", text: $tempItem.password)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
    }

//    private func SecurityWarningCard() -> some View {
//        HStack(spacing: 10) {
//            Image(systemName: "exclamationmark.triangle.fill")
//                .foregroundColor(.yellow)
//            Text("Mật khẩu yếu")
//                .font(.callout)
//            Spacer()
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.yellow.opacity(0.15))
//        )
//    }

    private func DeleteButtonSection() -> some View {
        Button(role: .destructive) {
            showActionSheetDelete = true
        } label: {
            Text("Xoá mật khẩu")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
        .confirmationDialog("", isPresented: $showActionSheetDelete, titleVisibility: .hidden) {
            Button("Xoá mật khẩu", role: .destructive) {
                viewModel.deleteItem()
            }
            Button("Huỷ", role: .cancel) {}
        } message: {
            Text("Mật khẩu này sẽ được di chuyển vào Đã xoá gần đây.\nSau 30 ngày, mật khẩu sẽ bị xoá vĩnh viễn.")
        }
    }

    private func InfoRow(title: String, value: String, onTap: @escaping () -> Void) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            Spacer()
            Button(action: onTap) {
                Image(systemName: "doc.on.doc")
            }
        }
    }

    private func EditableRow(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            TextField("", text: text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func copyToClipboard(_ value: String, label: String) {
        UIPasteboard.general.string = value
        copiedTextLabel = label
        withAnimation {
            showCopiedToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showCopiedToast = false
            }
        }
    }

    private var toastOverlay: some View {
        Group {
            if showCopiedToast {
                Text("\(copiedTextLabel.capitalized) đã được sao chép")
                    .font(.footnote)
                    .padding()
                    .background(Color(.systemGray4))
                    .cornerRadius(12)
                    .foregroundColor(.primary)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 50)
            }
        }
    }
}
