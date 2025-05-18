//
//  LockScreenView.swift
//  Passtify
//
//  Created by Phan Hoang Long on 18/5/25.
//

import SwiftUI

struct LockScreenView: View {
    @ObservedObject var viewModel: LockScreenViewModel

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.fill")
                .font(.system(size: 48))
                .padding()

            Text("Xác thực để tiếp tục")
                .font(.headline)

            ProgressView()
                .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                viewModel.authenticate()
            }
        }
    }
}

