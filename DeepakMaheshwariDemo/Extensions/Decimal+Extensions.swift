//
//  Decimal+Extensions.swift
//  DeepakMaheshwariDemo
//
//  Created by Deepak Maheshwari on 13/11/25.
//

import Foundation

extension Decimal {

    func toCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₹ "
        formatter.currencyCode = "INR"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        let number = NSDecimalNumber(decimal: self)
        return formatter.string(from: number) ?? "₹ 0.00"
    }
}


