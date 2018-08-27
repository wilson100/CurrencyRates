//
//  NumberFormatter.swift
//  CurrencyRates
//
//  Created by Filipp Ignatov on 27/08/2018.
//  Copyright © 2018 Филипп Игнатов. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static let currency: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1

        return formatter
    }()
}
