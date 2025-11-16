//
//  HoldingsService.swift
//  DeepakMaheshwariDemo
//
//  Created by Deepak Maheshwari on 13/11/25.
//

import Foundation

protocol HoldingsServiceProtocol {
    func fetchHoldings(completion: @escaping (Result<[HoldingModel], NetworkError>) -> Void)
    func loadFallbackHoldings() -> [HoldingModel]
}

final class HoldingsService: HoldingsServiceProtocol {
    
    private let networkManager: NetworkManagerProtocol
    private let endpoint = AppConstants.API.baseURL
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchHoldings(completion: @escaping (Result<[HoldingModel], NetworkError>) -> Void) {
        networkManager.request(endpoint) { (result: Result<HoldingsAPIResponse, NetworkError>) in
            switch result {
            case .success(let response):
                let holdings = response.data.userHolding
                completion(.success(holdings))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadFallbackHoldings() -> [HoldingModel] {
        guard let url = Bundle.main.url(forResource: "holdings_fallback", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(HoldingsAPIResponse.self, from: data)
            let holdings = response.data.userHolding
            return holdings
        } catch {
            return []
        }
    }
}


