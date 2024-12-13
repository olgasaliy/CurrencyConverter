//
//  UIViewController+Extension.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(message: String) {
        showAlert(title: "Error", message: message)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
