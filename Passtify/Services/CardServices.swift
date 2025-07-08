//
//  CardServices.swift
//  Passtify
//
//  Created by LONGPHAN on 8/7/25.
//
import Combine
import Foundation

protocol CardServiceProtocol {
    func saveCards(_ cards: [CardItemModel]) -> AnyPublisher<Void, Error>
    func loadCards() -> AnyPublisher<[CardItemModel], Error>
    func addCard(_ card: CardItemModel) -> AnyPublisher<[CardItemModel], Error>
    func updateCard(_ updatedItem: CardItemModel) -> AnyPublisher<Void, Error>
    func deleteCard(_ item: CardItemModel) -> AnyPublisher<Void, Error>
}

import Foundation
import Combine

final class CardService: CardServiceProtocol {
    
    func saveCards(_ cards: [CardItemModel]) -> AnyPublisher<Void, Error> {
        save(cards, to: FilePath.card)
    }

    func loadCards() -> AnyPublisher<[CardItemModel], Error> {
        load(FilePath.card)
    }

    func addCard(_ card: CardItemModel) -> AnyPublisher<[CardItemModel], Error> {
        return loadCards()
            .flatMap { current in
                var updated = current
                updated.append(card)
                return self.saveCards(updated)
                    .map { updated }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func updateCard(_ updatedItem: CardItemModel) -> AnyPublisher<Void, Error> {
        return loadCards()
            .flatMap { current -> AnyPublisher<Void, Error> in
                if let index = current.firstIndex(where: { $0.id == updatedItem.id }) {
                    var updated = current
                    updated[index] = updatedItem
                    return self.saveCards(updated)
                } else {
                    return Fail(error: NSError(domain: "", code: 404, userInfo: [
                        NSLocalizedDescriptionKey: "Card item not found"
                    ]))
                    .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    func deleteCard(_ item: CardItemModel) -> AnyPublisher<Void, Error> {
        return loadCards()
            .flatMap { current -> AnyPublisher<Void, Error> in
                let updated = current.filter { $0.id != item.id }
                return self.saveCards(updated)
            }
            .eraseToAnyPublisher()
    }
}

extension CardService {
    private func load(_ file: URL) -> AnyPublisher<[CardItemModel], Error> {
        Future { promise in
            do {
                let encryptedData = try Data(contentsOf: file)
                let decrypted = try CryptoManager.decrypt(encryptedData: encryptedData)
                let decoded = try JSONDecoder().decode([CardItemModel].self, from: decrypted)
                promise(.success(decoded.sorted { $0.creationDate > $1.creationDate }))
            } catch {
                if (error as NSError).code == NSFileReadNoSuchFileError {
                    promise(.success([])) // file chưa tồn tại -> return []
                } else {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    private func save(_ cards: [CardItemModel], to file: URL) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                let encoded = try JSONEncoder().encode(cards)
                let encrypted = try CryptoManager.encrypt(data: encoded)
                try encrypted.write(to: file)
                print("💾 Saved cards to: \(file.path)")
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
