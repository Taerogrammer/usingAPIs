//
//  ErrorCase.swift
//  0117_Networks
//
//  Created by 김태형 on 1/22/25.
//

import Foundation

enum UnsplashError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case unknown = 500
    case unknownTwo = 503

    var errorMessage: String {
        switch self {
        case .badRequest:
            return "400 badRequest"
        case .unauthorized:
            return "401 unauthorized"
        case .forbidden:
            return "403 forbidden"
        case .notFound:
            return "404 Not Found"
        case .unknown:
            return "500 unknown error"
        case .unknownTwo:
            return "503 unkown error"
        }
    }
}
