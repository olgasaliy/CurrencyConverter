//
//  DefaultCurrencyServiceTests.swift
//  CurrencyConverterTests
//
//  Created by Olha Salii on 16.12.2024.
//

import XCTest
@testable import CurrencyConverter

class DefaultCurrencyServiceTests: XCTestCase {
    var networkLoaderStub: NetworkLoaderStub!
    var currencyService: DefaultCurrencyService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        networkLoaderStub = NetworkLoaderStub()
        currencyService = DefaultCurrencyService(networkLoader: networkLoaderStub,
                                                 jsonLoader: networkLoaderStub)
    }
    
    override func tearDownWithError() throws {
        networkLoaderStub = nil
        currencyService = nil
        
        try super.tearDownWithError()
    }
    
    func testFetchCurrencies_CorrectResult() throws {
        let expectedCurrencies = [
            "USD": Currency(name: "US Dollar", code: "USD", symbol: "$", decimal_digits: 2)
        ]
        let encodedData = try! JSONEncoder().encode(expectedCurrencies)
        
        networkLoaderStub.result = .success(encodedData)
        
        let expectation = XCTestExpectation(description: "Fetch Currencies")
        var fetchedCurrencies: [String: Currency]?
        var fetchError: Error?
        
        currencyService.getCurrencies { result in
            switch result {
            case .success(let currencies):
                fetchedCurrencies = currencies
            case .failure(let error):
                fetchError = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertNil(fetchError)
        XCTAssertEqual(fetchedCurrencies, expectedCurrencies)
    }
    
    func testFetchCurrencies_NetworkFailure() throws {
        networkLoaderStub.result = .failure(URLError(.badServerResponse))
        
        let expectation = XCTestExpectation(description: "Handle Network Failure")
        var fetchError: Error?
        
        currencyService.getCurrencies { result in
            if case .failure(let error) = result {
                fetchError = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertNotNil(fetchError)
    }
    
    func testConvert_CorrectResult() throws {
        let expectedConversionResponse = CurrencyConversionResponse(amount: "100", currency: "USD")
        let encodedData = try! JSONEncoder().encode(expectedConversionResponse)
        
        networkLoaderStub.result = .success(encodedData)
        
        let expectation = XCTestExpectation(description: "Convert Currencies")
        let request = CurrencyConversionRequest(fromCurrency: "UAH",
                                                toCurrency: "USD",
                                                fromAmount: 50)
        var actualConversionResponse: CurrencyConversionResponse?
        var fetchError: Error?
        
        currencyService.convert(request: request) { result in
            switch result {
            case .success(let actualConversionResult):
                actualConversionResponse = actualConversionResult
            case .failure(let error):
                fetchError = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertNil(fetchError)
        XCTAssertEqual(actualConversionResponse, expectedConversionResponse)
    }
    
    func testConvert_NetworkFailure() throws {
        networkLoaderStub.result = .failure(URLError(.badServerResponse))
        
        let expectation = XCTestExpectation(description: "Handle Network Failure")
        var fetchError: Error?
        let request = CurrencyConversionRequest(fromCurrency: "UAH",
                                                toCurrency: "USD",
                                                fromAmount: 50)
        
        currencyService.convert(request: request) { result in
            if case .failure(let error) = result {
                fetchError = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertNotNil(fetchError)
    }
    
}
