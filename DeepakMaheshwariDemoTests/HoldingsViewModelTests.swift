//
//  HoldingsViewModelTests.swift
//  DeepakMaheshwariDemoTests
//
//  Created by Deepak Maheshwari on 13/11/25.
//

import XCTest
@testable import DeepakMaheshwariDemo

final class HoldingsViewModelTests: XCTestCase {
    
    var sut: HoldingsViewModel!
    var mockService: MockHoldingsService!
    
    override func setUp() {
        super.setUp()
        mockService = MockHoldingsService()
        sut = HoldingsViewModel(holdingsService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    // MARK: - Holdings Fetch Tests
    func testFetchHoldingsSuccess() {
        let expectation = self.expectation(description: "Holdings fetched successfully")
        mockService.shouldReturnError = false
        
        let delegate = MockHoldingsViewModelDelegate()
        sut.delegate = delegate
        
        sut.fetchHoldings()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(delegate.didUpdateHoldingsCalled)
            XCTAssertTrue(delegate.didStartLoadingCalled)
            XCTAssertTrue(delegate.didFinishLoadingCalled)
            XCTAssertFalse(delegate.didFailWithErrorCalled)
            XCTAssertGreaterThan(self.sut.numberOfHoldings(), 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchHoldingsFailure() {
        let expectation = self.expectation(description: "Holdings fetch failed")
        mockService.shouldReturnError = true
        
        let delegate = MockHoldingsViewModelDelegate()
        sut.delegate = delegate
        
        sut.fetchHoldings()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(delegate.didUpdateHoldingsCalled)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // MARK: - Calculation Tests
    func testPortfolioSummaryCalculations() {
        let holdings = [
            HoldingModel(symbol: "TEST1", quantity: 10, ltp: 100.0, avgPrice: 90.0, close: 95.0),
            HoldingModel(symbol: "TEST2", quantity: 5, ltp: 200.0, avgPrice: 180.0, close: 190.0)
        ]
        
        let summary = PortfolioSummary.calculate(from: holdings)
        
        XCTAssertEqual(summary.currentValue, Decimal(2000))
        XCTAssertEqual(summary.totalInvestment, Decimal(1800))
        XCTAssertEqual(summary.totalPnL, Decimal(200))
        XCTAssertEqual(summary.todaysPnL, Decimal(-100))
        
        let expectedPercentage = Decimal(200) / Decimal(1800) * 100
        XCTAssertEqual(summary.totalPnLPercentage, expectedPercentage)
    }
    
    func testHoldingModelCalculations() {
        let holding = HoldingModel(
            symbol: "TESTSTOCK",
            quantity: 10,
            ltp: 150.0,
            avgPrice: 100.0,
            close: 140.0
        )
        
        XCTAssertEqual(holding.currentValue, Decimal(1500))
        XCTAssertEqual(holding.totalInvestment, Decimal(1000))
        XCTAssertEqual(holding.totalPnL, Decimal(500))
        XCTAssertEqual(holding.todaysPnL, Decimal(-100))
        XCTAssertEqual(holding.totalPnLPercentage, Decimal(50))
    }
    
    func testNumberOfHoldings() {
        mockService.shouldReturnError = false
        let expectation = self.expectation(description: "Holdings loaded")
        
        sut.fetchHoldings()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.sut.numberOfHoldings(), 6)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testHoldingAtIndex() {
        mockService.shouldReturnError = false
        let expectation = self.expectation(description: "Holding retrieved")
        
        sut.fetchHoldings()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let holding = self.sut.holding(at: 0)
            XCTAssertNotNil(holding)
            XCTAssertEqual(holding?.symbol, "ASHOKLEY")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFormattedValues() {
        mockService.shouldReturnError = false
        let expectation = self.expectation(description: "Values formatted")
        
        sut.fetchHoldings()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let currentValue = self.sut.formattedCurrentValue()
            let totalInvestment = self.sut.formattedTotalInvestment()
            let totalPnL = self.sut.formattedTotalPnL()
            let todaysPnL = self.sut.formattedTodaysPnL()
            
            XCTAssertTrue(currentValue.contains("₹"))
            XCTAssertTrue(totalInvestment.contains("₹"))
            XCTAssertTrue(totalPnL.contains("₹"))
            XCTAssertTrue(todaysPnL.contains("₹"))
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

// MARK: - Mock Classes
class MockHoldingsService: HoldingsServiceProtocol {
    var shouldReturnError = false
    
    func fetchHoldings(completion: @escaping (Result<[HoldingModel], NetworkError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.serverError("Mock error")))
        } else {
            let holdings = [
                HoldingModel(symbol: "ASHOKLEY", quantity: 3, ltp: 119.10, avgPrice: 106.97, close: 120.00),
                HoldingModel(symbol: "HDFC", quantity: 7, ltp: 2497.20, avgPrice: 2713.91, close: 2500.00),
                HoldingModel(symbol: "ICICIBANK", quantity: 1, ltp: 624.70, avgPrice: 489.10, close: 625.00),
                HoldingModel(symbol: "IDEA", quantity: 3, ltp: 9.95, avgPrice: 9.02, close: 10.00),
                HoldingModel(symbol: "IDEA", quantity: 71, ltp: 9.95, avgPrice: 9.02, close: 10.00),
                HoldingModel(symbol: "INDHOTEL", quantity: 50, ltp: 142.75, avgPrice: 156.69, close: 143.00)
            ]
            completion(.success(holdings))
        }
    }
}

class MockHoldingsViewModelDelegate: HoldingsViewModelDelegate {
    var didUpdateHoldingsCalled = false
    var didFailWithErrorCalled = false
    var didStartLoadingCalled = false
    var didFinishLoadingCalled = false
    var errorMessage: String?
    
    func didUpdateHoldings() {
        didUpdateHoldingsCalled = true
    }
    
    func didFailWithError(_ error: String) {
        didFailWithErrorCalled = true
        errorMessage = error
    }
    
    func didStartLoading() {
        didStartLoadingCalled = true
    }
    
    func didFinishLoading() {
        didFinishLoadingCalled = true
    }
}


