//
//  CurrenciesRatesViewModel.swift
//  CurrencyRates
//
//  Created by Филипп Игнатов on 19.08.2018.
//  Copyright © 2018 Филипп Игнатов. All rights reserved.
//

import UIKit

class CurrenciesRatesViewModel {

    /// MARK: - Properties

    private let session: Session = Session()
    private var timer: Timer?
    private var state: LoadingState = .initialLoading {
        didSet {
            stateDidChange(state, oldValue)
        }
    }

    /// MARK: - Public interface
    var currenciesRates: CurrencyListResults = [:]
    var base = "EUR"

    var stateDidChange: (_ newState: LoadingState?, _ prevState: LoadingState?) -> Void = { _,_  in }

    var currencies: [Currency] = [
        Currency(currencyName: "EUR", currencyValue: 0, currencyDescription: "Euro", isBase: true),
        Currency(currencyName: "AUD", currencyValue: 0, currencyDescription: "Australian Dollar", isBase: false),
        Currency(currencyName: "BGN", currencyValue: 0, currencyDescription: "Bulgarian Lev", isBase: false),
        Currency(currencyName: "BRL", currencyValue: 0, currencyDescription: "Brazilian Real", isBase: false),
        Currency(currencyName: "CAD", currencyValue: 0, currencyDescription: "Canadian Dollar", isBase: false),
        Currency(currencyName: "CHF", currencyValue: 0, currencyDescription: "Swiss Franc", isBase: false),
        Currency(currencyName: "CNY", currencyValue: 0, currencyDescription: "Chinese Yuan", isBase: false),
        Currency(currencyName: "CZK", currencyValue: 0, currencyDescription: "Czech Koruna", isBase: false),
        Currency(currencyName: "DKK", currencyValue: 0, currencyDescription: "Danish Krone", isBase: false),
        Currency(currencyName: "GBP", currencyValue: 0, currencyDescription: "British Pound", isBase: false),
        Currency(currencyName: "HKD", currencyValue: 0, currencyDescription: "Hong Kong Dollar", isBase: false),
        Currency(currencyName: "HRK", currencyValue: 0, currencyDescription: "Croatian Kuna", isBase: false),
        Currency(currencyName: "HUF", currencyValue: 0, currencyDescription: "Hungarian Forint", isBase: false),
        Currency(currencyName: "IDR", currencyValue: 0, currencyDescription: "Indonesian Rupiah", isBase: false),
        Currency(currencyName: "ILS", currencyValue: 0, currencyDescription: "Israeli Shekel", isBase: false),
        Currency(currencyName: "INR", currencyValue: 0, currencyDescription: "Indian Rupee", isBase: false),
        Currency(currencyName: "ISK", currencyValue: 0, currencyDescription: "Icelandic Króna", isBase: false),
        Currency(currencyName: "JPY", currencyValue: 0, currencyDescription: "Japanese Yen", isBase: false),
        Currency(currencyName: "KRW", currencyValue: 0, currencyDescription: "South Korean Won", isBase: false),
        Currency(currencyName: "MXN", currencyValue: 0, currencyDescription: "Mexican Peso", isBase: false),
        Currency(currencyName: "MYR", currencyValue: 0, currencyDescription: "Malaysian Ringgit", isBase: false),
        Currency(currencyName: "NOK", currencyValue: 0, currencyDescription: "Norwegian Krone", isBase: false),
        Currency(currencyName: "NZD", currencyValue: 0, currencyDescription: "New Zealand Dollar", isBase: false),
        Currency(currencyName: "PHP", currencyValue: 0, currencyDescription: "Philippine Peso", isBase: false),
        Currency(currencyName: "PLN", currencyValue: 0, currencyDescription: "Polish Zloty", isBase: false),
        Currency(currencyName: "RON", currencyValue: 0, currencyDescription: "Romanian Leu", isBase: false),
        Currency(currencyName: "RUB", currencyValue: 0, currencyDescription: "Russian Ruble", isBase: false),
        Currency(currencyName: "SEK", currencyValue: 0, currencyDescription: "Swedish Krona", isBase: false),
        Currency(currencyName: "SGD", currencyValue: 0, currencyDescription: "Singapore Dollar", isBase: false),
        Currency(currencyName: "THB", currencyValue: 0, currencyDescription: "Thai Baht", isBase: false),
        Currency(currencyName: "TRY", currencyValue: 0, currencyDescription: "Turkish Lira", isBase: false),
        Currency(currencyName: "USD", currencyValue: 0, currencyDescription: "United States Dollar", isBase: false),
        Currency(currencyName: "ZAR", currencyValue: 0, currencyDescription: "South African Rand", isBase: false)
    ]
    
    func refresh() {
        if timer == nil {
            setTimer()
        }
    }

    func setBaseCurrency(with value: Double) {
        currencies[0].currencyValue = value
    }

    /// MARK: - Lifecycle
    init() {
        setTimer()
    }
    
    /// MARK: Private methods
    private func getCurrencies() {
        
        session.currenciesListService.getCurrenciesList(for: base) { [weak self] result, error  in
            guard error == nil else {
                
                self?.state = .error(error?.localizedDescription ?? "Failed to load")
                
                self?.timer?.invalidate()
                self?.timer = nil
                return
            }
            self?.currenciesRates = result ?? [:]
            self?.state = .loaded
        }
    }
    
    private func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func updateTimer() {
        getCurrencies()
    }
}
