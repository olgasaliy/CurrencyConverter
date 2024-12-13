//
//  CurrencySelectorTableViewCell.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import SnapKit
import UIKit

protocol CurrencyPickerCellDelegate: AnyObject {
    func currencyPickerCell(_ cell: CurrencyPickerCell,
                            didSelect index: Int,
                            inSection section: Int)
}

class CurrencyPickerCell: UITableViewCell {
    let pickerView = UIPickerView()
    weak var delegate: CurrencyPickerCellDelegate?
    
    private var currencies = [String]()
    private var section: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        configurePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(with currencies: [String], selectedCurrency: String?, sectionIndex: Int) {
        self.currencies = ["Select Currency"] + currencies
        self.section = sectionIndex
        
        // Refresh picker view content
        pickerView.reloadAllComponents()
        
        // Select the previously selected currency, if available
        if let selectedCurrency,
           let selectedIndex = currencies.firstIndex(of: selectedCurrency) {
            // Increment selectedIndex because of "Select Currency" placeholder
            pickerView.selectRow(selectedIndex + 1, inComponent: 0, animated: false)
        } else {
            // Default to "Select Currency" row
            pickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    private func configurePicker() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func setupViews() {
        contentView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}

extension CurrencyPickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencies.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row != 0 else { return }
        
        delegate?.currencyPickerCell(self,
                                     didSelect: row - 1, // Adjust index to exclude placeholder
                                     inSection: section)
    }
    
}
