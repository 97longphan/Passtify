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
            return "key.export_no_file".localized
        case .failedToCreateArchive:
            return "key.export_failed_zip".localized
        case .unknown(let err):
            return String(format: "key.export_unknown_error".localized, err.localizedDescription)
        }
    }
}

