//
//  CurrenciesRatesViewController.swift
//  CurrencyRates
//
//  Created by Филипп Игнатов on 18.08.2018.
//  Copyright © 2018 Филипп Игнатов. All rights reserved.
//

import UIKit
import SwiftMessages

class CurrenciesRatesViewController: UIViewController {
    
    /// MARK: - Definitions
    
    private struct Constants {
        static let cellHeight: CGFloat = 80
        static let firstIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    }
    
    /// MARK: - UI Outlets
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            
            tableView.register(cellType: CurrenciesRatesTableViewCell.self)
        }
    }
    
    /// MARK: - Properties
    private var viewModel: CurrenciesRatesViewModel! {
        didSet {
            viewModel?.stateDidChange = { [weak self] state, oldState  in
                
                switch (state, oldState) {
                case (.loaded?, .initialLoading?):
                    self?.viewModel.setBaseCurrency(with: 1.0)
                    DispatchQueue.main.async {
                        self?.update()
                        self?.tableView.reloadRows(at: [Constants.firstIndexPath], with: .none)
                    }
                case (.error(let errorDescription)?, _):
                    DispatchQueue.main.async {
                        self?.tableView.refreshControl?.endRefreshing()
                        
                       Messages.showError(title: "Error", body: errorDescription)
                    }
                case (.loaded?, _):
                    DispatchQueue.main.async {
                        self?.tableView.refreshControl?.endRefreshing()
                        self?.update()
                    }
                default: break
                }
            }
        }
    }
    
    private var scrollViewIsDecelerating: Bool = false
    private var indexPathToTop: IndexPath?
    
    private var refreshControl: UIRefreshControl?
    
    /// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.refreshControl = control
    }
    
    /// MARK: - Private methods
    
    private func setupViewModel() {
        
        viewModel = CurrenciesRatesViewModel()
    }
    
    private func update() {
        
        self.tableView.refreshControl?.endRefreshing()
        if !self.scrollViewIsDecelerating {

            for index in 0 ..< self.viewModel.currencies.count {
                let indexPath = IndexPath(row: index, section: 0)

                if let cell = self.tableView.cellForRow(at: indexPath) as? CurrenciesRatesTableViewCell {

                    let currencyName = self.viewModel.currencies[index].currencyName

                    if let base = self.viewModel.currencies.first?.currencyValue,
                        let rate = self.viewModel.currenciesRates[currencyName] {

                        self.viewModel.currencies[index].currencyValue = base * rate
                        cell.currencyData = self.viewModel.currencies[index]
                    }
                }
            }

            /// Update values of currencies in table cells
            self.tableView.numberOfRows(inSection: 0)
        }
    }
    
    private func moveToTop() {
        guard let indexPathToTop = indexPathToTop else { return }
        
        guard indexPathToTop != Constants.firstIndexPath else { return }
        
        viewModel.currencies[0].isBase = false
        var element = viewModel.currencies.remove(at: indexPathToTop.row)
        element.isBase = true
        viewModel.currencies.insert(element, at: 0)
        
        tableView.moveRow(at: indexPathToTop, to: Constants.firstIndexPath)
        viewModel.base = element.currencyName
        
        (tableView.cellForRow(at:
            Constants.firstIndexPath) as? CurrenciesRatesTableViewCell)?.setTextFieldAsFirstResponder()
        
        scrollViewIsDecelerating = false
        self.indexPathToTop = nil
    }
    
    @objc private func refreshAction() {
        viewModel.refresh()
    }
}

/// MARK: UITableViewDelegate, UITableViewDataSource

extension CurrenciesRatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrenciesRatesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.currencyData = viewModel.currencies[indexPath.row]
        
        cell.valueDidChange = { [weak self] newValue in
            guard let `self` = self else { return }
            
            self.viewModel.setBaseCurrency(with: newValue)
            
            DispatchQueue.main.async {
                for index in 1 ..< self.viewModel.currencies.count {
                    let indexPathToUpdate = IndexPath(row: index, section: 0)
                    
                    if let cell = self.tableView.cellForRow(at: indexPathToUpdate) as? CurrenciesRatesTableViewCell {
                        
                        let currencyName = self.viewModel.currencies[index].currencyName
                        
                        if let base = self.viewModel.currencies.first?.currencyValue,
                            let rate = self.viewModel.currenciesRates[currencyName] {
                            
                            self.viewModel.currencies[index].currencyValue = base * rate
                            cell.currencyData = self.viewModel.currencies[index]
                        }
                    }
                }
                self.tableView.numberOfRows(inSection: 0)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.indexPathsForVisibleRows?.contains(Constants.firstIndexPath))! {
            indexPathToTop = indexPath
            moveToTop()
        } else {
            indexPathToTop = indexPath
            scrollViewIsDecelerating = true
            tableView.setContentOffset(.zero, animated: true)
        }
    }
}

/// MARK: UIScrollViewDelegate
extension CurrenciesRatesViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        moveToTop()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewIsDecelerating = false
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollViewIsDecelerating = true
    }
}
