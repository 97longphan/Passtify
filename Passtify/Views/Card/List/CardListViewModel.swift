//
//  CardListViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 7/7/25.
//
import Combine
import Foundation

protocol CardListViewModelDelegate: AnyObject {
    func didAddNewCard()
    func didSelectCard()
}

class CardListViewModel: ViewModel {
    private weak var delegate: CardListViewModelDelegate?
    private var cancellables = Set<AnyCancellable>()
    private let cardService: CardServiceProtocol
    @Published var allCards: [CardItemModel] = []
    @Published var searchTerm: String = ""
    @Published var filteredList: [CardItemModel] = []
    
    init(cardService: CardServiceProtocol) {
        self.cardService = cardService
    }
    
    func setup(delegate: CardListViewModelDelegate) -> Self {
        self.delegate = delegate
        bind()
        return self
    }
    
    private func bind() {
        Publishers.CombineLatest($searchTerm, $allCards)
            .map { term, list in
                if term.isEmpty {
                    return list
                } else {
                    return list.filter {
                        $0.bankType.rawValue.localizedCaseInsensitiveContains(term)
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.filteredList, on: self)
            .store(in: &cancellables)
    }
    
    func onActionAddNewCard() {
        delegate?.didAddNewCard()
    }
    
    func onActionSelectCard(_ item: CardItemModel) {
        delegate?.didSelectCard()
    }
    
    func loadCards() {
        cardService.loadCards()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] cards in
                print(cards.first?.cardType)
                self?.allCards = cards
            }
            .store(in: &cancellables)
    }
}
