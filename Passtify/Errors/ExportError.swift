//
//  ExportError.swift
//  Passtify
//
//  Created by Phan Hoang Long on 9/5/25.
//
import Foundation

enum ExportError: Error {
    case noFile
    case failedToCreateArchive
    case unknown(Error)

    var msg: String {
        switch self {
        case .noFile:
            "Bạn hãy chắc chắn rằng có ít nhất một mật khẩu được lưu ^^"
        case .failedToCreateArchive:
            "Không thể tạo file nén. Vui lòng thử lại sau."
        case .unknown(let err):
            "Đã xảy ra lỗi: \(err.localizedDescription)"
        }
    }
}
