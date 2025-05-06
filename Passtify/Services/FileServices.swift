//
//  FileServices.swift
//  Passtify
//
//  Created by LONGPHAN on 5/5/25.
//

import Foundation
import ZIPFoundation
import CryptoKit

protocol FireServiceProtocol: AnyObject {
    func addJsonFileToZip(
        outputNameInZip: String,
        masterPassword: String
    )
}

final class FileService: FireServiceProtocol {
    func addJsonFileToZip(
        outputNameInZip: String,
        masterPassword: String
    ) {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let jsonFileURL = getJsonFileURL()

        do {
            // 1. Đọc dữ liệu JSON từ file mặc định
            let jsonData = try Data(contentsOf: jsonFileURL)

            // 2. Mã hóa
            let encryptedData = try CryptoManager.encrypt(data: jsonData, password: masterPassword)

            // 3. Ghi file .enc tạm thời
            let encFileURL = tempDir.appendingPathComponent(outputNameInZip)
            try encryptedData.write(to: encFileURL)

            // 4. Đường dẫn tới file ZIP
            let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let zipURL = documents.appendingPathComponent("data.zip")

            // 5. Tạo hoặc cập nhật file trong ZIP
            if !fileManager.fileExists(atPath: zipURL.path) {
                guard let archive = Archive(url: zipURL, accessMode: .create) else {
                    print("❌ Không thể tạo file ZIP")
                    return
                }
                try archive.addEntry(with: outputNameInZip, fileURL: encFileURL)
            } else {
                guard let archive = Archive(url: zipURL, accessMode: .update) else {
                    print("❌ Không thể mở file ZIP")
                    return
                }

                if let entry = archive[outputNameInZip] {
                    try archive.remove(entry)
                }

                try archive.addEntry(with: outputNameInZip, fileURL: encFileURL)
            }

            print("✅ Đã thêm '\(outputNameInZip)' vào data.zip")

        } catch {
            print("❌ Lỗi xử lý file JSON hoặc ZIP: \(error)")
        }
    }

    
    func getJsonFileURL() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("passwords.json")
        
        print(url)
        return url
    }

}
