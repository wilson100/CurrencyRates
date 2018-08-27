//
//  Messages.swift
//  CurrencyRates
//
//  Created by Filipp Ignatov on 27/08/2018.
//  Copyright © 2018 Филипп Игнатов. All rights reserved.
//

import SwiftMessages

enum Messages {
    static func showError(title: String, body: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.button?.isHidden = true

        // Theme message elements with the warning style.
        view.configureTheme(.error)

        // Add a drop shadow.
        view.configureDropShadow()

        view.configureContent(title: title, body: body)

        // Show the message.
        SwiftMessages.show(view: view)
    }
}
