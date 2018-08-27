//
//  CurrencyRatesTests.swift
//  CurrencyRatesTests
//
//  Created by Filipp Ignatov on 27/08/2018.
//  Copyright © 2018 Филипп Игнатов. All rights reserved.
//

import XCTest

@testable import CurrencyRates

class CurrencyRatesTests: XCTestCase {

    func testAPI() {
        let session: Session = Session()
        session.currenciesListService.getCurrenciesList(for: "EUR") { result, error  in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
        }
    }

    func testCurrenciesRatesFormat() {
        let currencyValue: Double = 1.9834
        let currencyValueString = NumberFormatter.currency.string(from: NSNumber(value: currencyValue))

        XCTAssertEqual(currencyValueString, "1,98")
    }
}
