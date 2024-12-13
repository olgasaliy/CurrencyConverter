//
//  CurrencySection.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 13.12.2024.
//
 
import Foundation

enum SectionType: Int, CaseIterable {
    case sourceCurrency
    case targetCurrency
    
    var title: String {
        switch self {
        case .sourceCurrency: return "Source Currency"
        case .targetCurrency: return "Target Currency"
        }
    }
}

struct Section {
    enum Row {
        case currencySelection
        case currencyPicker
        case currencyAmount
    }
    
    var currency: Currency?
    var amount: String
    var isEditable: Bool

    var rows: [Row] {
        return [
            .currencySelection,
            .currencyPicker,
            .currencyAmount
        ]
    }
}
