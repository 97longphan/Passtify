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
    func exportEncryptedDataAsZip() -> AnyPublisher<URL, ExportError>
    func importEncryptedDataFromZip(_ zipURL: URL) -> AnyPublisher<Void, Error>
}

final class FileService: FileServiceProtocol {
    func exportEncryptedDataAsZip() -> AnyPublisher<URL, ExportError> {
        return Future<URL, ExportError> { promise in
            let fileManager = FileManager.default

            do {

                // Bắt buộc phải có file passwords.enc
                guard fileManager.fileExists(atPath: FilePath.password.path) else {
                    throw ExportError.noFile
                }

                let tempDirectory = fileManager.temporaryDirectory
                let zipURL = tempDirectory.appendingPathComponent(Constants.FileName.zipBackup)

                if fileManager.fileExists(atPath: zipURL.path) {
                    try fileManager.removeItem(at: zipURL)
                }

                let archive = try Archive(url: zipURL, accessMode: .create)

                try archive.addEntry(with: Constants.FileName.password, fileURL: FilePath.password)

                if fileManager.fileExists(atPath: FilePath.deletedPassword.path) {
                    try archive.addEntry(with: Constants.FileName.deletedPassword, fileURL: FilePath.deletedPassword)
                }

                promise(.success(zipURL))
            } catch let error as ExportError {
                promise(.failure(error))
            } catch {
                // Nếu cần, bạn có thể thêm các loại ExportError khác ở đây
                promise(.failure(.noFile)) // fallback mặc định
            }
        }
        .eraseToAnyPublisher()
    }
    
    func importEncryptedDataFromZip(_ zipURL: URL) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            let fileManager = FileManager.default
            let destinationURL = fileManager.temporaryDirectory.appendingPathComponent(Constants.TempDirectory.importFolder, isDirectory: true)
            
            do {
                // Xoá thư mục tạm nếu đã tồn tại
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                
                try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
                
                // Giải nén file ZIP
                try fileManager.unzipItem(at: zipURL, to: destinationURL)
                
                // Kiểm tra và copy từng file nếu tồn tại
                let extractedPasswordURL = destinationURL.appendingPathComponent(Constants.FileName.password)
                let extractedDeletedURL = destinationURL.appendingPathComponent(Constants.FileName.deletedPassword)
                
                if fileManager.fileExists(atPath: extractedPasswordURL.path) {
                    let destinationPassword = FilePath.password
                    if fileManager.fileExists(atPath: destinationPassword.path) {
                        try fileManager.removeItem(at: destinationPassword)
                    }
                    try fileManager.copyItem(at: extractedPasswordURL, to: destinationPassword)
                }
                
                if fileManager.fileExists(atPath: extractedDeletedURL.path) {
                    let destinationDeleted = FilePath.deletedPassword
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
}
