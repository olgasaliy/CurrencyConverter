//
//  DefaultCurrencyService.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import Foundation

// Default Service Implementation
class DefaultCurrencyService: CurrencyServiceProtocol {
    private let baseCurrencyConversionURL = "http://api.evp.lt/currency/commercial/exchange/"
    
    private let networkLoader: DataLoader
    private let jsonLoader: DataLoader
    
    // Initializer for Dependency Injection
    init(networkLoader: DataLoader = NetworkLoader(), jsonLoader: DataLoader = JSONLoader()) {
        self.networkLoader = networkLoader
        self.jsonLoader = jsonLoader
    }
    
    // MARK: - Convert Currencies (Remote API)
    func convert(request: CurrencyConversionRequest, completion: @escaping (Result<CurrencyConversionResponse, Error>) -> Void) {
        let urlString = "\(baseCurrencyConversionURL)\(request.fromAmount)-\(request.fromCurrency)/\(request.toCurrency)/latest"

        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        networkLoader.fetchData(from: url, completion: completion)
    }
    
    // MARK: - Get Currencies (Local JSON)
    func getCurrencies(completion: @escaping (Result<[String: Currency], Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "currencies", withExtension: "json") else {
            completion(.failure(URLError(.fileDoesNotExist)))
            return
        }
        
        jsonLoader.fetchData(from: url, completion: completion)
    }
}
