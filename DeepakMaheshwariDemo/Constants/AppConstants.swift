//
//  AppConstants.swift
//  DeepakMaheshwariDemo
//
//  Created by Deepak Maheshwari on 13/11/25.
//

import Foundation

struct AppConstants {
    
    struct UIStrings {
        
        struct PortfolioSummary {
            static let profitAndLoss = "Profit & Loss*"
            static let currentValue = "Current value*"
            static let totalInvestment = "Total investment*"
            static let todaysProfitAndLoss = "Today's Profit & Loss*"
        }
        
        struct HoldingsCell {
            static let ltp = "LTP:"
            static let netQuantity = "NET QTY:"
            static let pnl = "P&L:"
        }
        
        struct ViewTitles {
            static let holdings = "Holdings"
        }
        
        struct ErrorMessages {
            static let invalidURL = "Oops! Something went wrong.\nPlease try again later."
            static let noData = "Please try again."
            static let decodingError = "We're having trouble loading your data.\nPlease try again in a moment."
            static let serverError = "Unable to reach the server.\nPlease try again."
            static let bannerConnectionError = "No internet connection.\nShowing cached data."
            static let bannerServerError = "Server error.\nShowing cached data."
            static let bannerTimeout = "Connection timeout.\nShowing cached data."
        }
        
        struct DefaultValues {
            static let currencyZero = "₹ 0.00"
            static let percentageZero = "(0.00%)"
            static let percentageFormat = "(%.2f%%)"
        }
    }
    
    struct API {
        static let baseURL = "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
    }
}
