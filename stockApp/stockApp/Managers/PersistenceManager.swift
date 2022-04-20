//
//  PersistenceManager.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/16.
//

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    // MARK: - Private
    // saving data using from UserDefaults
    private let userDefaults: UserDefaults = .standard

    
    private init() {}
    
    // MARK: - Public
    public var watchList: [String] {
        if !hasOnBoarded {
            userDefaults.set(true, forKey: Constant.onboardedKey)
            setupDefaults()
        }
        return userDefaults.stringArray(forKey: Constant.watchListKey) ?? []
    }
    
    public func addToWatchList() {
        
    }
    
    public func removeFromWatchList() {
        
    }
    
}

// MARK: - Private

private extension PersistenceManager {
    
    private struct Constant {
        static let onboardedKey: String = "hasOnBoarded"
        static let watchListKey = "watchList"
    }
    
    private var hasOnBoarded: Bool {
        return userDefaults.bool(forKey: Constant.onboardedKey)
    }
    
    private func setupDefaults() {
        let defaultsValues: [String: String] = [
            "MSFT": "Microsoft Corporation.",
            "SNAP": "Snap Inc.",
            "GOOG": "Alphabet.",
            "AMZN": "Amazon.com, Inc.",
            "FB": "Meta Plaforms, Inc.",
            "NVDA": "NVIDA Corporation.",
            "NKE": "NIKE.",
            "PINS": "Pinterest Inc.",
        ]
        
        let symbols = defaultsValues.keys.map { $0 }
        userDefaults.set(symbols, forKey: Constant.watchListKey)
        
        for (symbol, name) in defaultsValues {
            userDefaults.set(name, forKey: symbol)
        }
    }
}
