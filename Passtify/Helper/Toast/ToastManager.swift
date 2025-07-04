//
//  ToastManager.swift
//  Passtify
//
//  Created by Phan Hoang Long on 9/5/25.
//

import Combine
import Dispatch
import Foundation
import SwiftUI

struct Toast: Equatable {
    let message: String
    let type: ToastType
    let duration: TimeInterval = 2
}

final class ToastManager: ObservableObject {
    @Published var message: String = ""
    @Published var type: ToastType = .normal
    @Published var isPresented: Bool = false
    
    private var currentWorkItem: DispatchWorkItem?
    
    func show(_ toast: Toast) {
        // Ẩn toast hiện tại nếu đang có
        withAnimation(.easeOut(duration: 0.2)) {
            self.isPresented = false
        }
        
        // Hủy delay cũ
        currentWorkItem?.cancel()
        
        // Delay nhẹ trước khi hiện toast mới
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.message = toast.message
            self.type = toast.type
            withAnimation(.easeInOut(duration: 0.25)) {
                self.isPresented = true
            }
            
            // Schedule tự tắt
            let workItem = DispatchWorkItem { [weak self] in
                withAnimation(.easeOut(duration: 0.25)) {
                    self?.isPresented = false
                }
            }
            self.currentWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: workItem)
        }
    }
}
