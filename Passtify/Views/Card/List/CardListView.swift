//
//  CardListView.swift
//  Passtify
//
//  Created by LONGPHAN on 7/7/25.
//
import SwiftUI

import SwiftUI

struct CardListView: View {
    @ObservedObject var viewModel: CardListViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                if viewModel.filteredList.isEmpty {
                    CardListEmptyView()
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.filteredList, id: \.id) { item in
                        CardListItemView(cardItem: item) {
                            viewModel.onActionSelectCard(item)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .listStyle(.plain)
            .background(Color(UIColor.systemGroupedBackground))
            .searchable(text: $viewModel.searchTerm, prompt: "key.search_card_prompt".localized)
            .navigationTitle("key.my_cards_title".localized)
            .onAppear {
                viewModel.loadCards()
            }

            Button(action: {
                viewModel.onActionAddNewCard()
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.accentColor)
                    .padding()
                    .background(Color.accentColor.opacity(0.15))
                    .clipShape(Circle())
            }
            .padding()
        }
    }
}
