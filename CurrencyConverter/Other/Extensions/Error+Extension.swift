//
//  Error+Extension.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import Foundation

extension Error {
    var detailedDescription: String {
        if let error = self as? URLError {
            switch error.code {
            case .unsupportedURL, .badURL:
                return "The URL provided is invalid or unsupported."
            case .badServerResponse:
                return "The server returned an invalid response. Please try again later."
            case .zeroByteResource:
                return "The resource is empty. Please try again later or contact support."
            case .cannotDecodeRawData:
                return "The server returned data that could not be decoded. Ensure the data format is correct."
            case .networkConnectionLost:
                return "The network connection was lost. Please check your connection and try again."
            default:
                return error.localizedDescription
            }
        }
        
        return localizedDescription
    }
}
