//
//  LoadingState.swift
//  CurrencyRates
//
//  Created by Филипп Игнатов on 26.08.2018.
//  Copyright © 2018 Филипп Игнатов. All rights reserved.
//

import Foundation

enum LoadingState {
    case initialLoading
    case loaded
    case error(String)
}
