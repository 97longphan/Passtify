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
}

final class PasswordService: PasswordServiceProtocol {
    func savePasswords(_ passwords: [PasswordItemModel]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                let encoded = try JSONEncoder().encode(passwords)
                try encoded.write(to: self.getFileURL())
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
                let data = try Data(contentsOf: self.getFileURL())
                let decodedPasswords = try JSONDecoder().decode([PasswordItemModel].self, from: data)
                promise(.success(decodedPasswords))
            } catch {
                // Xử lý trường hợp file không tồn tại hoặc lỗi decoding
                if (error as NSError).code == NSFileReadNoSuchFileError {
                    promise(.success([])) // Trả về mảng rỗng nếu file không tồn tại
                } else {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getFileURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("passwords.json")
    }
}
