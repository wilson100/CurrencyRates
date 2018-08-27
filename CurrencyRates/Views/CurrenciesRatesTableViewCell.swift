//
//  CurrenciesRatesTableViewCell.swift
//  CurrencyRates
//
//  Created by Филипп Игнатов on 18.08.2018.
//  Copyright © 2018 Филипп Игнатов. All rights reserved.
//

import UIKit
import Reusable

class CurrenciesRatesTableViewCell: UITableViewCell, NibReusable {

    /// MARK: - UI Outlets
    @IBOutlet private var currencyNameLabel: UILabel!
    @IBOutlet private var currencyDescriptionLabel: UILabel!
    @IBOutlet private var currenctValueTextField: UITextField!
    @IBOutlet private var flagImageView: UIImageView!

    /// MARK: - Public interface
    
    var valueDidChange: ((_ newValue: Double) -> Void)?

    var currencyData: Currency? {
        didSet {
            currencyNameLabel.text = currencyData?.currencyName
            currencyDescriptionLabel.text = currencyData?.currencyDescription

            currenctValueTextField.text = currencyData?.currencyValue == 0 ?
                nil :
                NumberFormatter.currency.string(from: NSNumber(value: currencyData?.currencyValue ?? 0))

            flagImageView.image = currencyData?.flag
        }
    }

    func setTextFieldAsFirstResponder() {
        currenctValueTextField.becomeFirstResponder()
    }

    /// MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        flagImageView.layer.cornerRadius = 20
        flagImageView.layer.masksToBounds = true
        flagImageView.layer.borderColor = UIColor.lightGray.cgColor
        flagImageView.layer.borderWidth = 1 / UIScreen.main.scale
        
        currenctValueTextField.addTarget(self, action: #selector(change), for: .editingChanged)
    }

    /// MARK: Private methods
    
    @objc private func change() {
        var input: String = currenctValueTextField.text ?? ""
        input = input.replacingOccurrences(of: ",", with: ".")

        valueDidChange?(Double(input) ?? 0)
    }
}
