//
//  PasswordService.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//
import Combine
import Foundation
import AuthenticationServices

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
        save(passwords, to: FilePath.password)
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
        load(FilePath.password)
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
    
    func saveDeletedPasswords(_ passwords: [PasswordItemModel]) -> AnyPublisher<Void, Error> {
        save(passwords, to: FilePath.deletedPassword)
    }
    
    func loadDeletedPasswords() -> AnyPublisher<[PasswordItemModel], Error> {
        load(FilePath.deletedPassword)
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

}

extension PasswordService {
    private func load(_ file: URL) -> AnyPublisher<[PasswordItemModel], Error> {
        Future { promise in
            do {
                let encryptedData = try Data(contentsOf: file)
                let decrypted = try CryptoManager.decrypt(encryptedData: encryptedData)
                let decoded = try JSONDecoder().decode([PasswordItemModel].self, from: decrypted)
                self.saveAllCredentialIdentities(from: decoded)
                promise(.success(decoded.sorted { $0.creationDate > $1.creationDate }))
            } catch {
                if (error as NSError).code == NSFileReadNoSuchFileError {
                    promise(.success([]))
                } else {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    private func save(_ passwords: [PasswordItemModel], to file: URL) -> AnyPublisher<Void, Error> {
        
        Future { promise in
            do {
                let encoded = try JSONEncoder().encode(passwords)
                let encrypted = try CryptoManager.encrypt(data: encoded)
                try encrypted.write(to: file)
                print("🔐 Saving passwords to: \(FilePath.password.path)")
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    
    func saveAllCredentialIdentities(from credentials: [PasswordItemModel]) {
        let identities = credentials.compactMap { item -> ASPasswordCredentialIdentity? in
            let domain = item.domainOrLabel
            return ASPasswordCredentialIdentity(
                serviceIdentifier: ASCredentialServiceIdentifier(identifier: domain, type: .domain),
                user: item.userName,
                recordIdentifier: item.id.uuidString
            )
        }

        ASCredentialIdentityStore.shared.replaceCredentialIdentities(with: identities) { success, error in
            if success {
                print("✅ Saved \(identities.count) credential identities")
            } else {
                print("❌ Failed to save credential identities: \(error?.localizedDescription ?? "unknown error")")
            }
        }
        
    }

}
