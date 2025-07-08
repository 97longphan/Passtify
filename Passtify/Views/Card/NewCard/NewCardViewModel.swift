//
//  NewCardViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 7/7/25.
//
import Combine
import Foundation

protocol NewCardViewModelDelegate: AnyObject {
    func dismissNewCard()
    func didAddedNewCard()
}

class NewCardViewModel: ViewModel {
    @Published var input = CardItemModel.empty
    private weak var delegate: NewCardViewModelDelegate?
    private let cardService: CardServiceProtocol
    @Published var formattedCardNumber: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(cardService: CardServiceProtocol) {
        self.cardService = cardService
    }
    
    func setup(delegate: NewCardViewModelDelegate) -> Self {
        self.delegate = delegate
        bind()
        return self
    }
    
    func onDismissNewCard() {
        delegate?.dismissNewCard()
    }
    
    func onSaveNewCard() {
        cardService.addCard(input)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] _ in
                self?.delegate?.didAddedNewCard()
            }
            .store(in: &cancellables)
    }
    
    func isFormValid() -> Bool {
        return input.cardNumber.count == Constants.AppCard.validCardNumberLength && !input.cardHolderName.isEmpty && input.expiryDate.count == Constants.AppCard.validExpiryLength && input.cvv.count == Constants.AppCard.validCVVLength && input.bankType != .unknown
    }
    
    func bind() {
        
    }
}

