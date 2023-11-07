//
//  Item.swift
//  DarjCAst
//
//  Created by  pihta on 13.10.2023.
//

import Foundation
import SwiftData

@Model final class Item {
    var timestamp: Date
    var amount: Int // Add the amount property

    init(timestamp: Date, amount: Int) {
        self.timestamp = timestamp
        self.amount = amount // Initialize the amount property
    }
}
