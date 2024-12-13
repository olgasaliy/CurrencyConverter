//
//  UITableViewCell+Extension.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
