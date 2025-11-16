//
//  HoldingModel.swift
//  DeepakMaheshwariDemo
//
//  Created by Deepak Maheshwari on 13/11/25.
//

import Foundation

// MARK: - API Response
struct HoldingsAPIResponse: Codable {
    let data: HoldingsData
    
    struct HoldingsData: Codable {
        let userHolding: [HoldingModel]
    }
}

// MARK: - Holding Model
struct HoldingModel: Codable, Hashable {
    let symbol: String
    let quantity: Int
    let ltp: Decimal
    let avgPrice: Decimal
    let close: Decimal
    
    var currentValue: Decimal {
        ltp * Decimal(quantity)
    }
    
    var totalInvestment: Decimal {
        avgPrice * Decimal(quantity)
    }
    
    var totalPnL: Decimal {
        currentValue - totalInvestment
    }
    
    var todaysPnL: Decimal {
        (close - ltp) * Decimal(quantity)
    }
    
    var totalPnLPercentage: Decimal {
        guard totalInvestment > 0 else { return 0 }
        return (totalPnL / totalInvestment) * 100
    }
    
    // MARK: - Initialization
    init(symbol: String, quantity: Int, ltp: Double, avgPrice: Double, close: Double) {
        self.symbol = symbol
        self.quantity = quantity
        self.ltp = Decimal(ltp)
        self.avgPrice = Decimal(avgPrice)
        self.close = Decimal(close)
    }
    
    enum CodingKeys: String, CodingKey {
        case symbol, quantity, ltp, avgPrice, close
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try container.decode(String.self, forKey: .symbol)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        let ltpDouble = try container.decode(Double.self, forKey: .ltp)
        let avgPriceDouble = try container.decode(Double.self, forKey: .avgPrice)
        let closeDouble = try container.decode(Double.self, forKey: .close)
        
        ltp = Decimal(ltpDouble)
        avgPrice = Decimal(avgPriceDouble)
        close = Decimal(closeDouble)
    }
}

// MARK: - Portfolio Summary Model
struct PortfolioSummary {
    let currentValue: Decimal
    let totalInvestment: Decimal
    let totalPnL: Decimal
    let todaysPnL: Decimal
    
    var totalPnLPercentage: Decimal {
        guard totalInvestment > 0 else { return 0 }
        return (totalPnL / totalInvestment) * 100
    }
    
    static func calculate(from holdings: [HoldingModel]) -> PortfolioSummary {
        var currentValue = Decimal(0)
        var totalInvestment = Decimal(0)
        var todaysPnL = Decimal(0)
        
        for holding in holdings {
            currentValue += holding.currentValue
            totalInvestment += holding.totalInvestment
            todaysPnL += holding.todaysPnL
        }
        
        let totalPnL = currentValue - totalInvestment
        
        return PortfolioSummary(
            currentValue: currentValue,
            totalInvestment: totalInvestment,
            totalPnL: totalPnL,
            todaysPnL: todaysPnL
        )
    }
}