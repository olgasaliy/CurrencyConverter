//
//  CurrencyServiceProtocol.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import Foundation

// Defines a service for handling currency-related operations
protocol CurrencyServiceProtocol {
    func convert(request: CurrencyConversionRequest,
                 completion: @escaping (Result<CurrencyConversionResponse, Error>) -> Void)
    func getCurrencies(completion: @escaping (Result<[String: Currency], Error>) -> Void)
}
