//
//  HoldingsViewModel.swift
//  DeepakMaheshwariDemo
//
//  Created by Deepak Maheshwari on 13/11/25.
//

import Foundation

protocol HoldingsViewModelDelegate: AnyObject {
    func didUpdateHoldings()
    func didLoadFallbackData(error: String)
    func didStartLoading()
    func didFinishLoading()
}

final class HoldingsViewModel {
    
    // MARK: - Properties
    private let holdingsService: HoldingsServiceProtocol
    private(set) var holdings: [HoldingModel] = []
    private(set) var portfolioSummary: PortfolioSummary?
    
    weak var delegate: HoldingsViewModelDelegate?
    
    // MARK: - Initialization
    init(holdingsService: HoldingsServiceProtocol = HoldingsService()) {
        self.holdingsService = holdingsService
    }
    
    // MARK: - Public Methods
    func fetchHoldings() {
        delegate?.didStartLoading()
        
        holdingsService.fetchHoldings { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.delegate?.didFinishLoading()
                
                switch result {
                case .success(let holdings):
                    self.holdings = holdings
                    self.portfolioSummary = PortfolioSummary.calculate(from: holdings)
                    self.delegate?.didUpdateHoldings()
                    
                case .failure(let error):
                    let fallbackHoldings = self.holdingsService.loadFallbackHoldings()
                    self.holdings = fallbackHoldings
                    self.portfolioSummary = PortfolioSummary.calculate(from: fallbackHoldings)
                    
                    let bannerMessage: String
                    switch error {
                    case .noInternetConnection:
                        bannerMessage = AppConstants.UIStrings.ErrorMessages.bannerConnectionError
                    case .timeout:
                        bannerMessage = AppConstants.UIStrings.ErrorMessages.bannerTimeout
                    case .noData, .serverError:
                        bannerMessage = AppConstants.UIStrings.ErrorMessages.bannerServerError
                    default:
                        bannerMessage = AppConstants.UIStrings.ErrorMessages.bannerServerError
                    }
                    
                    self.delegate?.didLoadFallbackData(error: bannerMessage)
                }
            }
        }
    }
    
    func numberOfHoldings() -> Int {
        return holdings.count
    }
    
    func holding(at index: Int) -> HoldingModel? {
        guard index >= 0 && index < holdings.count else { return nil }
        return holdings[index]
    }
    
    // MARK: - Formatted Values
    func formattedCurrentValue() -> String {
        guard let summary = portfolioSummary else { return AppConstants.UIStrings.DefaultValues.currencyZero }
        return summary.currentValue.toCurrencyString()
    }
    
    func formattedTotalInvestment() -> String {
        guard let summary = portfolioSummary else { return AppConstants.UIStrings.DefaultValues.currencyZero }
        return summary.totalInvestment.toCurrencyString()
    }
    
    func formattedTotalPnL() -> String {
        guard let summary = portfolioSummary else { return AppConstants.UIStrings.DefaultValues.currencyZero }
        return summary.totalPnL.toCurrencyString()
    }
    
    func formattedTodaysPnL() -> String {
        guard let summary = portfolioSummary else { return AppConstants.UIStrings.DefaultValues.currencyZero }
        return summary.todaysPnL.toCurrencyString()
    }
    
    func formattedPnLPercentage() -> String {
        guard let summary = portfolioSummary else { return AppConstants.UIStrings.DefaultValues.percentageZero }
        let percentage = summary.totalPnLPercentage
        return String(format: AppConstants.UIStrings.DefaultValues.percentageFormat, NSDecimalNumber(decimal: percentage).doubleValue)
    }
    
    func isPnLPositive() -> Bool {
        guard let summary = portfolioSummary else { return false }
        return summary.totalPnL >= 0
    }
    
    func isTodaysPnLPositive() -> Bool {
        guard let summary = portfolioSummary else { return false }
        return summary.todaysPnL >= 0
    }
}

// MARK: - Cell ViewModel
extension HoldingsViewModel {
    func cellViewModel(at index: Int) -> HoldingCellViewModel? {
        guard let holding = holding(at: index) else { return nil }
        return HoldingCellViewModel(holding: holding)
    }
}

// MARK: - Holding Cell ViewModel
struct HoldingCellViewModel {
    private let holding: HoldingModel
    
    init(holding: HoldingModel) {
        self.holding = holding
    }
    
    var symbol: String {
        return holding.symbol
    }
    
    var quantity: String {
        return "\(holding.quantity)"
    }
    
    var ltp: String {
        return holding.ltp.toCurrencyString()
    }
    
    var totalPnL: String {
        return holding.totalPnL.toCurrencyString()
    }
    
    var isPnLPositive: Bool {
        return holding.totalPnL >= 0
    }
}


