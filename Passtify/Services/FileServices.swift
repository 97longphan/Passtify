//
//  FileServices.swift
//  Passtify
//
//  Created by LONGPHAN on 5/5/25.
//

import Foundation
import ZIPFoundation
import Combine
import CryptoKit

protocol FileServiceProtocol: AnyObject {
    func exportEncryptedDataAsZip() -> AnyPublisher<URL, Error>
    func importEncryptedDataFromZip(_ zipURL: URL) -> AnyPublisher<Void, Error>
}

final class FileService: FileServiceProtocol {
    func exportEncryptedDataAsZip() -> AnyPublisher<URL, Error> {
        return Future<URL, Error> { promise in
            let fileManager = FileManager.default
            
            // Đường dẫn đến hai file cần zip
            let passwordURL = self.passwordUrl()
            let deletedPasswordURL = self.deletePasswordUrl()
            
            do {
                // Tạo thư mục tạm để chứa file zip
                let tempDirectory = fileManager.temporaryDirectory
                let zipURL = tempDirectory.appendingPathComponent("PasswordsBackup.zip")
                
                // Xoá nếu đã tồn tại
                if fileManager.fileExists(atPath: zipURL.path) {
                    try fileManager.removeItem(at: zipURL)
                }
                
                // Tạo file zip
                guard let archive = Archive(url: zipURL, accessMode: .create) else {
                    throw NSError(domain: "ZIP", code: 1, userInfo: [NSLocalizedDescriptionKey: "Không tạo được file zip"])
                }
                
                try archive.addEntry(with: "passwords.enc", fileURL: passwordURL)
                try archive.addEntry(with: "deletepasswords.enc", fileURL: deletedPasswordURL)
                
                promise(.success(zipURL))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func importEncryptedDataFromZip(_ zipURL: URL) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            let fileManager = FileManager.default
            let destinationURL = fileManager.temporaryDirectory.appendingPathComponent("ImportTemp", isDirectory: true)
            
            do {
                // Xoá thư mục tạm nếu đã tồn tại
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                
                try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
                
                // Giải nén file ZIP
                try fileManager.unzipItem(at: zipURL, to: destinationURL)
                
                // Kiểm tra và copy từng file nếu tồn tại
                let extractedPasswordURL = destinationURL.appendingPathComponent("passwords.enc")
                let extractedDeletedURL = destinationURL.appendingPathComponent("deletepasswords.enc")
                
                if fileManager.fileExists(atPath: extractedPasswordURL.path) {
                    let destinationPassword = self.passwordUrl()
                    if fileManager.fileExists(atPath: destinationPassword.path) {
                        try fileManager.removeItem(at: destinationPassword)
                    }
                    try fileManager.copyItem(at: extractedPasswordURL, to: destinationPassword)
                }
                
                if fileManager.fileExists(atPath: extractedDeletedURL.path) {
                    let destinationDeleted = self.deletePasswordUrl()
                    if fileManager.fileExists(atPath: destinationDeleted.path) {
                        try fileManager.removeItem(at: destinationDeleted)
                    }
                    try fileManager.copyItem(at: extractedDeletedURL, to: destinationDeleted)
                }
                
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func passwordUrl() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("passwords.enc")
        return url
    }
    
    private func deletePasswordUrl() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("deletepasswords.enc")
    }
    
}
