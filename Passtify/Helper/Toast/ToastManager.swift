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

final class ToastManager: ObservableObject {
    @Published var message: String = ""
    @Published var type: ToastType = .normal
    @Published var isPresented: Bool = false
    
    private var currentWorkItem: DispatchWorkItem?
    
    func show(_ message: String, type: ToastType = .normal, duration: TimeInterval = 2) {
        // Ẩn toast hiện tại nếu đang có
        withAnimation(.easeOut(duration: 0.2)) {
            self.isPresented = false
        }
        
        // Hủy delay cũ
        currentWorkItem?.cancel()
        
        // Delay nhẹ trước khi hiện toast mới
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.message = message
            self.type = type
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
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
        }
    }
}
