//
//  CurrenciesListService.swift
//  CurrencyRates
//
//  Created by Филипп Игнатов on 19.08.2018.
//  Copyright © 2018 Филипп Игнатов. All rights reserved.
//

import Foundation
import Alamofire

typealias CurrencyListResults = [String: Double]

class CurrenciesListService {
    
    /// Receive currencies rates
    ///
    /// - Parameters:
    ///   - base: base currency
    ///   - completion: complition block
    func getCurrenciesList(for base: String = "EUR", completion: @escaping ((CurrencyListResults?, Error?) -> Void)) {
        let url = URL(string: "https://revolut.duckdns.org/latest?base=\(base)")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            if let content = data
            {
                do
                {
                    let myJson = try JSONSerialization.jsonObject(with: content,
                                                                  options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    if let rates = myJson["rates"] as? NSDictionary,
                        let myRates = rates as? CurrencyListResults
                    {
                        completion(myRates, nil)
                    }
                } catch let error {
                    Messages.showError(title: "Error", body: error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
