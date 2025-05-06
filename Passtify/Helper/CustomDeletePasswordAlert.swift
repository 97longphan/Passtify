//
//  CustomDeletePasswordAlert.swift
//  Passtify
//
//  Created by LONGPHAN on 6/5/25.
//
import SwiftUI

struct CustomDeletePasswordAlert: View {
    var onConfirm: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Mật khẩu này sẽ được di chuyển vào Đã xoá gần đây.\nSau 30 ngày, mật khẩu sẽ bị xoá vĩnh viễn.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(.subheadline)
                    .background(Color(UIColor.systemBackground))
                
                Divider()
                
                Button(role: .destructive) {
                    onConfirm()
                } label: {
                    Text("Xoá mật khẩu")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color(UIColor.systemBackground))
                
                Divider()
                
                Button {
                    onCancel()
                } label: {
                    Text("Huỷ")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color(UIColor.systemBackground))
            }
            .frame(maxWidth: 300)
            .cornerRadius(14)
            .shadow(radius: 10)
        }
    }
}
