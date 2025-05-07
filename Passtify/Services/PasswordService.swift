//
//  PasswordService.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//
import Combine
import Foundation

protocol PasswordServiceProtocol {
    func savePasswords(_ passwords: [PasswordItemModel]) -> AnyPublisher<Void, Error>
    func loadPasswords() -> AnyPublisher<[PasswordItemModel], Error>
    func addPassword(_ password: PasswordItemModel) -> AnyPublisher<[PasswordItemModel], Error>
    func updatePassword(_ updatedItem: PasswordItemModel) -> AnyPublisher<Void, Error>
    func deletePassword(_ item: PasswordItemModel) -> AnyPublisher<Void, Error>
    //
    func saveDeletedPasswords(_ passwords: [PasswordItemModel]) -> AnyPublisher<Void, Error>
    func loadDeletedPasswords() -> AnyPublisher<[PasswordItemModel], Error>
    func addDeletedPassword(_ password: PasswordItemModel) -> AnyPublisher<Void, Error>
    func recoverDeletedPassword(_ password: PasswordItemModel) -> AnyPublisher<Void, Error>
    func permanentlyDeletePassword(_ item: PasswordItemModel) -> AnyPublisher<Void, Error>
}

final class PasswordService: PasswordServiceProtocol {
    private let fileService = FileService()
    private let masterPassword = "12345"
    
    func deletePassword(_ item: PasswordItemModel) -> AnyPublisher<Void, Error> {
        return loadPasswords()
            .flatMap { currentPasswords -> AnyPublisher<Void, Error> in
                let updatedPasswords = currentPasswords.filter { $0.id != item.id }
                return self.savePasswords(updatedPasswords)
                    .flatMap { _ in
                        self.addDeletedPassword(item)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    
    func savePasswords(_ passwords: [PasswordItemModel]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                let encoded = try JSONEncoder().encode(passwords)
                let encrypted = try CryptoManager.encrypt(data: encoded, password: self.masterPassword)
                try encrypted.write(to: self.passwordUrl())
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addPassword(_ password: PasswordItemModel) -> AnyPublisher<[PasswordItemModel], Error> {
        return loadPasswords()
            .flatMap { currentPasswords in
                var updatedPasswords = currentPasswords
                updatedPasswords.append(password)
                return self.savePasswords(updatedPasswords)
                    .map { updatedPasswords }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func loadPasswords() -> AnyPublisher<[PasswordItemModel], Error> {
        return Future<[PasswordItemModel], Error> { promise in
            do {
                let encryptedData = try Data(contentsOf: self.passwordUrl())
                let decryptedData = try CryptoManager.decrypt(encryptedData: encryptedData, password: self.masterPassword)
                let decoded = try JSONDecoder().decode([PasswordItemModel].self, from: decryptedData)
                let sorted = decoded.sorted { $0.creationDate > $1.creationDate }
                promise(.success(sorted))
            } catch {
                if (error as NSError).code == NSFileReadNoSuchFileError {
                    promise(.success([]))
                } else {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updatePassword(_ updatedItem: PasswordItemModel) -> AnyPublisher<Void, Error> {
        return loadPasswords()
            .flatMap { (currentPasswords: [PasswordItemModel]) -> AnyPublisher<Void, Error> in
                if let index = currentPasswords.firstIndex(where: { $0.id == updatedItem.id }) {
                    var updatedPasswords = currentPasswords
                    updatedPasswords[index] = updatedItem
                    return self.savePasswords(updatedPasswords)
                } else {
                    return Fail(error: NSError(domain: "", code: 404, userInfo: [
                        NSLocalizedDescriptionKey: "Password item not found"
                    ]))
                    .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    private func passwordUrl() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("passwords.enc")
        return url
    }
    
    func saveDeletedPasswords(_ passwords: [PasswordItemModel]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                let encoded = try JSONEncoder().encode(passwords)
                let encrypted = try CryptoManager.encrypt(data: encoded, password: self.masterPassword)
                try encrypted.write(to: self.deletePasswordUrl())
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func loadDeletedPasswords() -> AnyPublisher<[PasswordItemModel], Error> {
        return Future<[PasswordItemModel], Error> { promise in
            do {
                let encryptedData = try Data(contentsOf: self.deletePasswordUrl())
                let decryptedData = try CryptoManager.decrypt(encryptedData: encryptedData, password: self.masterPassword)
                let decoded = try JSONDecoder().decode([PasswordItemModel].self, from: decryptedData)
                let sorted = decoded.sorted { $0.creationDate > $1.creationDate }
                promise(.success(sorted))
            } catch {
                if (error as NSError).code == NSFileReadNoSuchFileError {
                    promise(.success([]))
                } else {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addDeletedPassword(_ password: PasswordItemModel) -> AnyPublisher<Void, Error> {
        return loadDeletedPasswords()
            .flatMap { currentPasswords in
                var updatedPasswords = currentPasswords
                updatedPasswords.append(password)
                return self.saveDeletedPasswords(updatedPasswords)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func recoverDeletedPassword(_ password: PasswordItemModel) -> AnyPublisher<Void, Error> {
        return addPassword(password)
            .flatMap { _ in
                self.permanentlyDeletePassword(password)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func permanentlyDeletePassword(_ item: PasswordItemModel) -> AnyPublisher<Void, Error> {
        return loadDeletedPasswords()
            .flatMap { currentPasswords -> AnyPublisher<Void, Error> in
                let updatedPasswords = currentPasswords.filter { $0.id != item.id }
                return self.saveDeletedPasswords(updatedPasswords)
            }
            .eraseToAnyPublisher()
    }
    
    private func deletePasswordUrl() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("deletepasswords.enc")
    }
}
