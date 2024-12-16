//
//  CurrencyTableViewModelDelegateMock.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 16.12.2024.
//

import XCTest
@testable import CurrencyConverter

class CurrencyTableViewModelDelegateMock: CurrencyTableViewModelDelegate {
    var didGetCurrenciesCalled = false
    var shouldReloadRowCalled = false
    var didErrorOccurCalled = false
    var didStartLoadingCalled = false
    
    var reloadedIndexPath: IndexPath?
    var errorMessage: String?
    var isLoading = false

    func didGetCurrencies() {
        didGetCurrenciesCalled = true
    }

    func shouldReloadRow(at indexPath: IndexPath?) {
        shouldReloadRowCalled = true
        reloadedIndexPath = indexPath
    }

    func didErrorOccur(error: String) {
        didErrorOccurCalled = true
        errorMessage = error
    }
    
    func didStartLoading(_ startLoading: Bool) {
        didStartLoadingCalled = true
        isLoading = startLoading
    }
}
