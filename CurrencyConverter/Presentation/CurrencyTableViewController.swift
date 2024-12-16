//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import UIKit

class CurrencyTableViewController: UITableViewController {
    var viewModel: CurrencyTableViewModel?
    
    private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Currency Converter"
        setupTableView()
        setupActivityIndicator()
        registerTapRecognizer()
    }

    // MARK: - Setup Methods
    private func setupTableView() {
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.reuseIdentifier)
        tableView.register(CurrencyAmountCell.self, forCellReuseIdentifier: CurrencyAmountCell.reuseIdentifier)
        tableView.register(CurrencyPickerCell.self, forCellReuseIdentifier: CurrencyPickerCell.reuseIdentifier)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        let activityItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = activityItem
    }

    private func registerTapRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel?.titleForHeader(in: section)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSections() ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows(in: section) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel,
              let row = viewModel.row(for: indexPath),
              let sectionModel = viewModel.section(at: indexPath.section) else {
            return UITableViewCell()
        }

        switch row {
        case .currencySelection:
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.reuseIdentifier, for: indexPath) as! CurrencyCell
            cell.configure(with: sectionModel.currency?.name ?? "")
            return cell

        case .currencyPicker:
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyPickerCell.reuseIdentifier, for: indexPath) as! CurrencyPickerCell
            cell.configure(
                with: viewModel.getListOfCurrenciesCodes(),
                selectedCurrency: sectionModel.currency?.code,
                sectionIndex: indexPath.section
            )
            cell.delegate = self
            return cell

        case .currencyAmount:
            let amount = sectionModel.amount
            let isEditable = sectionModel.isEditable

            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyAmountCell.reuseIdentifier, for: indexPath) as! CurrencyAmountCell
            cell.configure(with: amount, isEditable: isEditable)

            // Handle TextField Changes
            cell.amountChanged = { [weak self] newAmount in
                self?.viewModel?.updateAmount(newAmount, at: indexPath.section)
            }
            return cell
        }
    }
}

// MARK: - CurrencyPickerCellDelegate
extension CurrencyTableViewController: CurrencyPickerCellDelegate {
    func currencyPickerCell(_ cell: CurrencyPickerCell, didSelect index: Int, inSection section: Int) {
        viewModel?.updateSelectedCurrency(toIndex: index, inSection: section)
    }
}

// MARK: - CurrencyTableViewModelDelegate
extension CurrencyTableViewController: CurrencyTableViewModelDelegate {
    func shouldReloadRow(at indexPath: IndexPath?) {
        guard let indexPath else {
            tableView.reloadData()
            return
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func didGetCurrencies() {
        tableView.reloadData()
    }

    func didErrorOccur(error: String) {
        showErrorAlert(message: error)
    }
    
    func didStartLoading(_ startLoading: Bool) {
        if startLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

