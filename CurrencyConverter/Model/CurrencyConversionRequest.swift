//
//  CurrencyConversionRequest.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import Foundation

struct CurrencyConversionRequest {
    let fromCurrency: String
    let toCurrency: String
    let fromAmount: Double
}

struct CurrencyConversionResponse: Codable {
    let amount: String
    let currency: String
}
