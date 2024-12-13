//
//  MainViewModel.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import Foundation

protocol CurrencyTableViewModelDelegate: AnyObject {
    func didGetCurrencies()
    func shouldReloadRow(at indexPath: IndexPath?)
    func didErrorOccur(error: String)
}

class CurrencyTableViewModel {
    private(set) var sections = [SectionType: Section]()

    private var currencies: [Currency] = []
    private let service: CurrencyService
    private weak var delegate: CurrencyTableViewModelDelegate?
    private var debounceTimer: DispatchWorkItem?

    // MARK: - Init
    init(service: CurrencyService, delegate: CurrencyTableViewModelDelegate?) {
        self.service = service
        self.delegate = delegate
        setupSections()
        fetchCurrencies()
    }

    // MARK: - TableView Accessors
    func titleForHeader(in section: Int) -> String {
        guard let sectionType = SectionType(rawValue: section) else { return "" }
        return sectionType.title
    }

    func numberOfSections() -> Int {
        return sections.count
    }

    func numberOfRows(in section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        return sections[sectionType]?.rows.count ?? 0
    }

    func row(for indexPath: IndexPath) -> Section.Row? {
        guard let sectionType = SectionType(rawValue: indexPath.section) else { return nil }
        return sections[sectionType]?.rows[indexPath.row]
    }

    func section(at index: Int) -> Section? {
        guard let sectionType = SectionType(rawValue: index),
              let section = sections[sectionType] else {
            return nil
        }
        
        return section
    }

    // MARK: - Updates
    func updateAmount(_ newAmount: String, at sectionIndex: Int) {
        guard let sectionType = SectionType(rawValue: sectionIndex),
                var section = sections[sectionType] else {
            return
        }
        
        section.amount = newAmount
        sections[sectionType] = section
        triggerCurrencyConversion()
    }
    
    func updateSelectedCurrency(toIndex index: Int, inSection sectionIndex: Int) {
        guard let sectionType = SectionType(rawValue: sectionIndex),
                var section = sections[sectionType] else {
            return
        }
        
        section.currency = currencies[index]
        sections[sectionType] = section
        let currencyCellIndexPath = indexPath(for: .currencySelection, in: sectionType)
        delegate?.shouldReloadRow(at: currencyCellIndexPath)
        triggerCurrencyConversion()
    }

    func getListOfCurrenciesCodes() -> [String] {
        return currencies.map { $0.code }
    }

    // MARK: - Conversion Logic
    private func triggerCurrencyConversion() {
        debounceTimer?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            guard
                let sourceSection = self?.sections[.sourceCurrency],
                let targetSection = self?.sections[.targetCurrency],
                !sourceSection.amount.isEmpty,
                let fromAmount = Double(sourceSection.amount),
                let fromCurrency = sourceSection.currency,
                let toCurrency = targetSection.currency
            else { return }

            let request = CurrencyConversionRequest(
                fromCurrency: fromCurrency.code,
                toCurrency: toCurrency.code,
                fromAmount: fromAmount
            )

            self?.convertCurrency(request)
        }

        debounceTimer = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }

    private func convertCurrency(_ request: CurrencyConversionRequest) {
        DispatchQueue.global().async { [weak self] in
            self?.service.convert(request: request) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let conversionResult):
                        self?.sections[.targetCurrency]?.amount = "\(conversionResult.amount)"
                        let targetIndex = self?.indexPath(for: .currencyAmount, in: .targetCurrency)
                        self?.delegate?.shouldReloadRow(at: targetIndex)
                    case .failure(let error):
                        self?.delegate?.didErrorOccur(error: error.detailedDescription)
                    }
                }
            }
        }
    }

    // MARK: - Currencies Fetching
    private func fetchCurrencies() {
        service.getCurrencies { [weak self] result in
            switch result {
            case .success(let currenciesResult):
                self?.currencies = currenciesResult.values.sorted { $0.name < $1.name }
                self?.delegate?.didGetCurrencies()
            case .failure(let error):
                self?.delegate?.didErrorOccur(error: error.detailedDescription)
            }
        }
    }
    
    // MARK: - Helpers
    private func setupSections() {
        sections = [
            .sourceCurrency: Section(currency: nil, amount: "", isEditable: true),
            .targetCurrency: Section(currency: nil, amount: "", isEditable: false)
        ]
    }
    
    private func indexPath(for row: Section.Row, in sectionType: SectionType) -> IndexPath? {
        guard let section = sections[sectionType],
              let rowIndex = section.rows.firstIndex(of: row) else {
            return nil
        }
        return IndexPath(row: rowIndex, section: sectionType.rawValue)
    }
}
