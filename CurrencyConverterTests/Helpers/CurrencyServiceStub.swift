//
//  CurrencyServiceStub.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 16.12.2024.
//

import XCTest
@testable import CurrencyConverter

class CurrencyServiceStub: CurrencyService {
    var mockCurrencies: [String: Currency] = [:]
    var conversionResult: Result<CurrencyConversionResponse, Error>?
    var currenciesFetchResult: Result<[String: Currency], Error>?

    func convert(request: CurrencyConversionRequest, completion: @escaping (Result<CurrencyConversionResponse, Error>) -> Void) {
        if let result = conversionResult {
            completion(result)
        }
    }

    func getCurrencies(completion: @escaping (Result<[String: Currency], Error>) -> Void) {
        if let result = currenciesFetchResult {
            completion(result)
        }
    }
}
