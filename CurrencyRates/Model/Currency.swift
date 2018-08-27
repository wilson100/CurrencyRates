//
//  Currency.swift
//  CurrencyRates
//
//  Created by Филипп Игнатов on 18.08.2018.
//  Copyright © 2018 Филипп Игнатов. All rights reserved.
//

import UIKit

struct Currency {
    // MARK: - Properties
    
    let currencyName: String
    var currencyValue: Double
    var flag: UIImage? {
        get {
            return UIImage(named: currencyName)
        }
    }
    let currencyDescription: String?
    var isBase: Bool
}
