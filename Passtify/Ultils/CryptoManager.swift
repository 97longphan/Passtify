//
//  CryptoManager.swift
//  Passtify
//
//  Created by LONGPHAN on 5/5/25.
//

import Foundation
import CryptoKit
enum CryptoError: Error {
    case invalidData
    case decryptionFailed
}

final class CryptoManager {
    /// Dẫn xuất SymmetricKey từ password và salt bằng HKDF
    private static func deriveKey(from password: String, salt: Data) -> SymmetricKey {
        let passwordData = Data(password.utf8)
        return SymmetricKey(
            data: HKDF<SHA256>.deriveKey(
                inputKeyMaterial: SymmetricKey(data: passwordData),
                salt: salt,
                info: Data(),
                outputByteCount: 32
            )
        )
    }

    /// Mã hóa dữ liệu bằng AES-GCM
    static func encrypt(data: Data, password: String = "") throws -> Data {
        let salt = Data((0..<16).map { _ in UInt8.random(in: 0...255) })
        let key = deriveKey(from: password, salt: salt)
        let nonce = AES.GCM.Nonce()
        let sealedBox = try AES.GCM.seal(data, using: key, nonce: nonce)
        let nonceData = Data(nonce)

        // Kết cấu: [salt (16)] + [nonce (12)] + [ciphertext] + [tag (16)]
        return salt + nonceData + sealedBox.ciphertext + sealedBox.tag
    }

    /// Giải mã dữ liệu đã mã hóa bằng AES-GCM
    static func decrypt(encryptedData: Data, password: String = "") throws -> Data {
        guard encryptedData.count > (16 + 12 + 16) else {
            throw CryptoError.invalidData
        }

        let salt = encryptedData.prefix(16)
        let nonceData = encryptedData.subdata(in: 16..<28)
        let tag = encryptedData.suffix(16)
        let ciphertext = encryptedData.subdata(in: 28..<(encryptedData.count - 16))

        let key = deriveKey(from: password, salt: salt)
        let nonce = try AES.GCM.Nonce(data: nonceData)

        let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        return try AES.GCM.open(sealedBox, using: key)
    }
}
