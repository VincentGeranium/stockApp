//
//  ChangePercentageManager.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/21.
//

import Foundation
import UIKit

final class ChangePercentageManager {
    static let shared = ChangePercentageManager()
    
    private init() {}
    
    public func getChangePercentage(symbol: String, data:[CandleStick]) -> Double {
        let latestDate = data[0].date
        
        guard let latestClose = data.first?.close,
              let priorClose = data.first(where: { !Calendar.current.isDate($0.date, inSameDayAs: latestDate )})?.close
        else { return 0.0 }
        
        let diff = 1 - (priorClose/latestClose)
        
//        print("\(symbol): \(diff)%")
        
        return diff
    }

}
