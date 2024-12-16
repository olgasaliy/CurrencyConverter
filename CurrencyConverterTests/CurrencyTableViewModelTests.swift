//
//  CurrencyTableViewModelTests.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 16.12.2024.
//

import XCTest
@testable import CurrencyConverter

class CurrencyTableViewModelTests: XCTestCase {
    var mockService: CurrencyServiceStub!
    var mockDelegate: CurrencyTableViewModelDelegateMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = CurrencyServiceStub()
        mockDelegate = CurrencyTableViewModelDelegateMock()
    }

    override func tearDownWithError() throws {
        mockService = nil
        mockDelegate = nil
        try super.tearDownWithError()
    }
    
    func testInitialization_setsUpSectionsCorrectly() {
        let viewModel = CurrencyTableViewModel(service: mockService, delegate: mockDelegate)
        XCTAssertEqual(viewModel.numberOfSections(), 2)
    }
    
    func testFetchCurrencies_callsDelegateOnSuccess() {
        mockService.currenciesFetchResult = .success([
            "USD": Currency(name: "US Dollar", code: "USD", symbol: "$", decimal_digits: 2)
        ])
        let _ = CurrencyTableViewModel(service: mockService, delegate: mockDelegate)

        XCTAssertTrue(mockDelegate.didGetCurrenciesCalled)
    }
    
    func testFetchCurrencies_callsDelegateOnFailure() {
        mockService.currenciesFetchResult = .failure(URLError(.badServerResponse))
        let _ = CurrencyTableViewModel(service: mockService, delegate: mockDelegate)
        XCTAssertTrue(mockDelegate.didErrorOccurCalled)
    }

    func testUpdateSelectedCurrency_shouldReloadRow() {
        mockService.currenciesFetchResult = .success([
            "USD": Currency(name: "US Dollar", code: "USD", symbol: "$", decimal_digits: 2),
            "EUR": Currency(name: "Euro", code: "EUR", symbol: "€", decimal_digits: 2)
        ])
        let viewModel = CurrencyTableViewModel(service: mockService, delegate: mockDelegate)

        viewModel.updateSelectedCurrency(toIndex: 1, inSection: 0)
        
        XCTAssertTrue(mockDelegate.shouldReloadRowCalled)
        XCTAssertEqual(mockDelegate.reloadedIndexPath, IndexPath(row: 0, section: 0))
    }
    
    func testTriggerCurrencyConversion_callsDelegateStartLoading() {
        mockService.conversionResult = .success(
            CurrencyConversionResponse(amount: "123.45", currency: "USD")
        )
        mockService.currenciesFetchResult = .success([
            "USD": Currency(name: "US Dollar", code: "USD", symbol: "$", decimal_digits: 2),
            "EUR": Currency(name: "Euro", code: "EUR", symbol: "€", decimal_digits: 2)
        ])
        let viewModel = CurrencyTableViewModel(service: mockService, delegate: mockDelegate)
        viewModel.updateAmount("100", at: 0)
        viewModel.updateSelectedCurrency(toIndex: 0, inSection: 0)
        viewModel.updateSelectedCurrency(toIndex: 1, inSection: 1)
                
        let expectation = XCTestExpectation(description: "Should trigger loading state")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.mockDelegate.didStartLoadingCalled)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
    func testTriggerCurrencyConversion_handlesConversionSuccess() {
        mockService.conversionResult = .success(
            CurrencyConversionResponse(amount: "123.45", currency: "USD")
        )
        mockService.currenciesFetchResult = .success([
            "USD": Currency(name: "US Dollar", code: "USD", symbol: "$", decimal_digits: 2),
            "EUR": Currency(name: "Euro", code: "EUR", symbol: "€", decimal_digits: 2)
        ])
        let viewModel = CurrencyTableViewModel(service: mockService, delegate: mockDelegate)
        viewModel.updateAmount("100", at: 0)
        viewModel.updateSelectedCurrency(toIndex: 0, inSection: 0)
        viewModel.updateSelectedCurrency(toIndex: 1, inSection: 1)

        let expectation = XCTestExpectation(description: "Should wait for Reloading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.mockDelegate.shouldReloadRowCalled)
            XCTAssertEqual(viewModel.section(at: 1)?.amount, "123.45")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
    func testTriggerCurrencyConversion_handlesConversionFailure() {
        mockService.conversionResult = .failure(URLError(.badServerResponse))
        mockService.currenciesFetchResult = .success([
            "USD": Currency(name: "US Dollar", code: "USD", symbol: "$", decimal_digits: 2),
            "EUR": Currency(name: "Euro", code: "EUR", symbol: "€", decimal_digits: 2)
        ])
        let viewModel = CurrencyTableViewModel(service: mockService, delegate: mockDelegate)
        
        viewModel.updateAmount("100", at: 0)
        viewModel.updateSelectedCurrency(toIndex: 0, inSection: 0)
        viewModel.updateSelectedCurrency(toIndex: 1, inSection: 1)

        let expectation = XCTestExpectation(description: "Should wait for Reloading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.mockDelegate.didErrorOccurCalled)
            XCTAssertEqual(self.mockDelegate.errorMessage, URLError(.badServerResponse).detailedDescription)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testStartTimer_triggersRepeatedFunction() {
        mockService.conversionResult = .success(
            CurrencyConversionResponse(amount: "100.0", currency: "USD")
        )
        mockService.currenciesFetchResult = .success([
            "USD": Currency(name: "US Dollar", code: "USD", symbol: "$", decimal_digits: 2),
            "EUR": Currency(name: "Euro", code: "EUR", symbol: "€", decimal_digits: 2)
        ])
        let viewModel = CurrencyTableViewModel(service: mockService, delegate: mockDelegate)
        
        viewModel.updateAmount("10", at: 0)
        viewModel.updateSelectedCurrency(toIndex: 0, inSection: 0)
        viewModel.updateSelectedCurrency(toIndex: 1, inSection: 1)

        mockDelegate.didStartLoadingCalled = false
        
        let expectation = XCTestExpectation(description: "Should trigger loading state")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            XCTAssertTrue(self.mockDelegate.didStartLoadingCalled)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 11.0)
    }
}
