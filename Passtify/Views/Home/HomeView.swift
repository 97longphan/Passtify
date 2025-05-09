//
//  HomeView.swift
//  Passtify
//
//  Created by LONGPHAN on 30/4/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State var searchTerm = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    ForEach(viewModel.categories) { item in
                        Button(action: {
                            viewModel.handleCategoryTap(item: item)
                        }) {
                            HomeCardItemView(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("NHÓM ĐƯỢC CHIA SẺ")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                        Text("Nhóm được chia sẻ mới")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationBarTitle("Mật khẩu")
        .searchable(text: $searchTerm, prompt: "Tìm kiếm")
        .onAppear {
            viewModel.loadCount()
        }
    }
}

