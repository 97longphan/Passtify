//
//  HomeCardItemView.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//
import SwiftUI

//struct HomeCardItemView: View {
//    let item: HomeItemCategoryModel
//    
//    var body: some View {
//        RoundedRectangle(cornerRadius: 10)
//            .fill(Color(.secondarySystemBackground)) // Nền thích ứng
//            .frame(height: 90)
//            .overlay(
//                HStack {
//                    VStack(alignment: .leading) {
//                        ZStack(alignment: .center) {
//                            Circle()
//                                .frame(width: 32, height: 32)
//                                .foregroundColor(item.type.iconBackgroundColor)
//                            
//                            Image(systemName: item.type.iconName)
//                                .font(.headline)
//                                .foregroundColor(.white)
//                        }
//                        
//                        Text(item.type.title)
//                            .font(.footnote)
//                            .foregroundStyle(.primary)
//                    }
//                    Spacer()
//                    if item.type.isShowCount {
//                        Text("\(item.count) >")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                }
//                    .padding()
//                , alignment: .leading
//            )
//    }
//}
//
//struct HomeCardItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeCardItemView(item: .init(type: .deleted, count: 0))
//    }
//}
