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
    public func financialMetrics(
        for symbol: String,
        completion: @escaping (Result<FinancialMetricsResponse, Error>) -> Void
    ) {
        let url = url(
            for: .financial,
            queryParams: ["symbol": symbol, "metric": "all"]
        )
        
        request(
            url: url,
            expecting: FinancialMetricsResponse.self,
            completion: completion
        )
    }
    
    public func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = url(for: .search, queryParams: ["q":safeQuery]) else { return }
        request(url: url, expecting: SearchResponse.self, completion: completion)
        
    }
    
    public func news(for type: NewsViewController.ControllerType, completion: @escaping (Result<[NewsStroy], Error>) -> Void) {
        switch type {
        case .topStories:
            let url = url(
                for: .topStories,
                queryParams: ["category":"general"]
            )
            request(url: url, expecting: [NewsStroy].self, completion: completion)
            
        case .company(let symbol):
            let today = Date().addingTimeInterval(-(Constants.day))
            let oneMonthBack = today.addingTimeInterval(-(Constants.day * 7))
            
            let url = url(
                for: .companyNews,
                queryParams: [
                    "symbol": symbol,
                    "from": DateFormatter.newsDateFormatter.string(from: oneMonthBack),
                    "to": DateFormatter.newsDateFormatter.string(from: today)
                ]
            )
            request(url: url, expecting: [NewsStroy].self, completion: completion)
        }
    }
    
    public func marketData(for symbol: String, numberOfDays: TimeInterval = 7, completion: @escaping (Result<MarketDataResponse, Error>) -> Void) {
        
//        let today = Date().addingTimeInterval(-(Constants.day))
//        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        
        let today = Date().addingTimeInterval(-(Constants.day))
        
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        
        let url = url(
            for: .marketData,
            queryParams: [
                "symbol": symbol,
                "resolution": "1",
                "from": "\(Int(prior.timeIntervalSince1970))",
                "to": "\(Int(today.timeIntervalSince1970))"
            ]
        )
        
        request(
            url: url,
            expecting: MarketDataResponse.self,
            completion: completion
        )
    }
}

// MARK: - Private
private extension APIManager {
    private struct Constants {
        static let apiKey = "c9d9u2iad3iboaghgvpg"
        static let sandboxApiKey = "sandbox_c9d9u2iad3iboaghgvq0"
        static let baseURL = "https://finnhub.io/api/v1"
        static let day: TimeInterval = 3600 * 24
    }
    
    private enum EndPoint: String {
        case search = "/search"
        case topStories = "/news"
        case companyNews = "/company-news"
        case marketData = "/stock/candle"
        case financial = "/stock/metric"
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidURL
    }
    
    private func url(for endPoint: EndPoint, queryParams: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseURL + endPoint.rawValue
        
        var queryItems = [URLQueryItem]()
        // Add any parameters
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        
        // Add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        // Convert query items to suffix string
        let queryString = queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        urlString += "?" + queryString
        
//        print("\n\(urlString)\n")
        
        return URL(string: urlString)
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
