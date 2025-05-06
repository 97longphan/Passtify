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
        VStack {
            content
        }
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
                        // 👉 Khi ấn "Xong", lưu dữ liệu
                        viewModel.updateItem(newItem: tempItem)
                    } else {
                        // 👉 Khi bắt đầu sửa, sao chép từ model sang state tạm
                        tempItem = viewModel.passwordItem
                    }
                    editing.toggle()
                    
                }
            }
        }
        .overlay(toastOverlay, alignment: .bottom)
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
    
    private func editView() -> some View {
        Form {
            // 📌 SECTION 1: Header + Tên người dùng
            Section {
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(viewModel.passwordItem.label.prefix(1).uppercased())
                                .font(.title)
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading) {
                        TextField("", text: $tempItem.label)
                            .font(.headline)
                            .bold()
                        Text("Sửa đổi: \(formattedDate(viewModel.passwordItem.creationDate))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Text("Tên người dùng")
                    Spacer()
                    TextField("", text: $tempItem.userName)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.secondary)
                        .frame(width: 180)
                }
            }
            
            // 🔒 SECTION 2: Mật khẩu riêng
            Section {
                HStack {
                    Text("Mật khẩu")
                    Spacer()
                    TextField("", text: $tempItem.password)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.secondary)
                        .frame(width: 180)
                }
            }
            
            // 🌐 SECTION 4: Trang web & ghi chú
            Section {
                HStack {
                    Text("Trang web")
                    Spacer()
                    Text("Không có trang web")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Ghi chú")
                    Spacer()
                    Text(" ")
                        .foregroundColor(.secondary)
                }
            }
            
            // ❌ SECTION 5: Xóa
            Section {
                Button(role: .destructive) {
                    showActionSheetDelete = true
                } label: {
                    Text("Xóa")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .confirmationDialog(
                    "",
                    isPresented: $showActionSheetDelete,
                    titleVisibility: .hidden
                ) {
                    Button("Xoá mật khẩu", role: .destructive) {
                        viewModel.deleteItem()
                    }
                    
                    Button("Huỷ", role: .cancel) {}
                } message: {
                    Text("Mật khẩu này sẽ được di chuyển vào Đã xoá gần đây.\nSau 30 ngày, mật khẩu sẽ bị xoá vĩnh viễn.")
                }
            }
        }
    }
    
    
    private func detailView() -> some View {
        Form {
            Section {
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(viewModel.passwordItem.label.prefix(1).uppercased())
                                .font(.title)
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.passwordItem.label)
                            .font(.headline)
                            .bold()
                        Text("Sửa đổi: \(formattedDate(viewModel.passwordItem.creationDate))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section(header: Text("Thông tin đăng nhập")) {
                HStack {
                    Text("Tên người dùng")
                    Spacer()
                    Text(viewModel.passwordItem.userName)
                        .foregroundColor(.secondary)
                }.onTapGesture {
                    copyToClipboard(viewModel.passwordItem.userName, label: "tên người dùng")
                }
                
                HStack {
                    Text("Mật khẩu")
                    Spacer()
                    Text("••••••••")
                        .foregroundColor(.secondary)
                }.onTapGesture {
                    copyToClipboard(viewModel.passwordItem.password, label: "mật khẩu")
                }
            }
            
            Section {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.yellow)
                    Text("Mật khẩu yếu")
                }
            }
        }
    }
    
    
    @ViewBuilder
    private var content: some View {
        if editing {
            editView()
        } else {
            detailView()
        }
    }
    
    private var toastOverlay: some View {
        Group {
            if showCopiedToast {
                Text("Đã sao chép \(copiedTextLabel)")
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
