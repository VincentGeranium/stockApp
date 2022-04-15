//
//  APIManager.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/16.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    // MARK: - Public
    
    // get stock info
    
    // search stock
}

// MARK: - Private
private extension APIManager {
    private struct Constants {
        static let apiKey = ""
        static let sandboxApiKey = ""
        static let baseURL = ""
    }
    
    private enum EndPoint: String {
        case search
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidURL
    }
    
    private func url(for endPoint: EndPoint, queryParams: [String: String] = [:]) -> URL? {
        return nil
    }
    
    private func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            // Invalid url
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
