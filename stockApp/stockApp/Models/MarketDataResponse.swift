//
//  MarketDataResponse.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/19.
//

import Foundation

struct MarketDataResponse: Codable {
    let close: [Double]
    let high: [Double]
    let low: [Double]
    let open: [Double]
    let status: String
    let timeStamp: [TimeInterval]
    let volume: [Int]
    
    enum CodingKeys: String, CodingKey {
        case close = "c"
        case high = "h"
        case low = "l"
        case open = "o"
        case status = "s"
        case timeStamp = "t"
        case volume = "v"
    }
    
    var candleSticks: [CandleStick] {
        var result = [CandleStick]()
        
        for index in 0..<open.count {
            result.append(
                .init(
                    date: Date(timeIntervalSince1970: timeStamp[index]),
                    close: close[index],
                    high: high[index],
                    low: low[index],
                    open: open[index]
                )
            )
        }
        
        let sortedData = result.sorted(by: {$0.date > $1.date })
        
        return sortedData
    }
}

struct CandleStick {
    let date: Date
    let close: Double
    let high: Double
    let low: Double
    let open: Double
}
