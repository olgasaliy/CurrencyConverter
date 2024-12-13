//
//  CurrencyAmountInputTableViewCell.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import UIKit

class CurrencyAmountCell: UITableViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.text = "Amount"
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        return textField
    }()
    
    var amountChanged: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        amountChanged?(sender.text ?? "")
    }
    
    func configure(with amount: String, isEditable: Bool) {
        textField.text = amount
        textField.borderStyle = isEditable ? .roundedRect : .none
        textField.isUserInteractionEnabled = isEditable
    }
    
    private func setupViews() {
        selectionStyle = .none
        contentView.addSubview(label)
        contentView.addSubview(textField)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
        }
        
        textField.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-16)
            make.centerY.equalTo(contentView)
            make.left.greaterThanOrEqualTo(label.snp.right).offset(8)
            make.width.greaterThanOrEqualTo(contentView.snp.width).multipliedBy(0.4)
        }
    }
}
