//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import Foundation

struct Currency: Codable, Equatable {
    let name: String
    let code: String
    let symbol: String
    let decimal_digits: Int
}
