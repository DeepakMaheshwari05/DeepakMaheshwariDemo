//
//  NetworkManager.swift
//  DeepakMaheshwariDemo
//
//  Created by Deepak Maheshwari on 13/11/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case noInternetConnection
    case serverError(String)
    case timeout
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return AppConstants.UIStrings.ErrorMessages.invalidURL
        case .noData:
            return AppConstants.UIStrings.ErrorMessages.noData
        case .decodingError:
            return AppConstants.UIStrings.ErrorMessages.decodingError
        case .noInternetConnection:
            return AppConstants.UIStrings.ErrorMessages.serverError
        case .serverError:
            return AppConstants.UIStrings.ErrorMessages.serverError
        case .timeout:
            return AppConstants.UIStrings.ErrorMessages.serverError
        }
    }
}

protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ endpoint: String, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                // Check for specific network error types
                let nsError = error as NSError
                
                switch nsError.code {
                case NSURLErrorNotConnectedToInternet,
                     NSURLErrorNetworkConnectionLost,
                     NSURLErrorDataNotAllowed:
                    completion(.failure(.noInternetConnection))
                    
                case NSURLErrorTimedOut:
                    completion(.failure(.timeout))
                    
                case NSURLErrorCannotConnectToHost,
                     NSURLErrorCannotFindHost,
                     NSURLErrorDNSLookupFailed:
                    completion(.failure(.serverError("Cannot reach server")))
                    
                default:
                    completion(.failure(.serverError(error.localizedDescription)))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}


