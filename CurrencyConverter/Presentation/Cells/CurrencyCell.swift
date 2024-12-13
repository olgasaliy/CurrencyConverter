//
//  MainTableViewCell.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import UIKit
import SnapKit

class CurrencyCell: UITableViewCell {
    let leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.text = "Currency"
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with currencyName: String?) {
        rightLabel.text = currencyName
    }
    
    private func setupViews() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
    }
    
    private func setupConstraints() {
        leftLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-16)
            make.centerY.equalTo(contentView)
            make.left.greaterThanOrEqualTo(leftLabel.snp.right).offset(8)
        }
    }
}
