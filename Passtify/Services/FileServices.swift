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
                let tempDirectory = fileManager.temporaryDirectory
                let zipURL = tempDirectory.appendingPathComponent(Constants.FileName.zipBackup)

                if fileManager.fileExists(atPath: zipURL.path) {
                    try fileManager.removeItem(at: zipURL)
                }

                let archive = try Archive(url: zipURL, accessMode: .create)

                var addedAnyFile = false

                if fileManager.fileExists(atPath: FilePath.password.path) {
                    try archive.addEntry(with: Constants.FileName.password, fileURL: FilePath.password)
                    addedAnyFile = true
                }

                if fileManager.fileExists(atPath: FilePath.deletedPassword.path) {
                    try archive.addEntry(with: Constants.FileName.deletedPassword, fileURL: FilePath.deletedPassword)
                    addedAnyFile = true
                }

                if fileManager.fileExists(atPath: FilePath.card.path) {
                    try archive.addEntry(with: Constants.FileName.card, fileURL: FilePath.card)
                    addedAnyFile = true
                }

                if addedAnyFile {
                    promise(.success(zipURL))
                } else {
                    throw ExportError.noFile
                }

            } catch let error as ExportError {
                promise(.failure(error))
            } catch {
                promise(.failure(.noFile))
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

                var importedAnyFile = false

                // Copy từng file nếu tồn tại
                let filesToImport: [(source: URL, destination: URL)] = [
                    (destinationURL.appendingPathComponent(Constants.FileName.password), FilePath.password),
                    (destinationURL.appendingPathComponent(Constants.FileName.deletedPassword), FilePath.deletedPassword),
                    (destinationURL.appendingPathComponent(Constants.FileName.card), FilePath.card)
                ]

                for (sourceURL, destURL) in filesToImport {
                    if fileManager.fileExists(atPath: sourceURL.path) {
                        if fileManager.fileExists(atPath: destURL.path) {
                            try fileManager.removeItem(at: destURL)
                        }
                        try fileManager.copyItem(at: sourceURL, to: destURL)
                        importedAnyFile = true
                    }
                }

                if importedAnyFile {
                    promise(.success(()))
                } else {
                    promise(.failure(ImportError.noFile))
                }

            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

}
