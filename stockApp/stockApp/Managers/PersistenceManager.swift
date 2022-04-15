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
    private let  userDefaults: UserDefaults = .standard

    
    private init() {}
    
    // MARK: - Public
    public var watchList: [String] {
        return []
    }
    
    public func addToWatchList() {
        
    }
    
    public func removeFromWatchList() {
        
    }
    
}

// MARK: - Private

private extension PersistenceManager {
    
    private struct Constant {
        
    }
    
    private var hasOnBoarded: Bool {
        return false
    }
}
