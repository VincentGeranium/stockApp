//
//  FinancialMetricsResponse.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/21.
//

import Foundation

struct FinancialMetricsResponse: Codable {
    let metric: Metrics
}

struct Metrics: Codable {
    let tenDayAverageTradingVolume: Float
    let annualWeekHigh: Double
    let annualWeekLow: Double
    let annualWeekLowDate: String
    let annualWeekPriceReturnDaily: Double
    let beta: Float
    
    enum CodingKeys: String, CodingKey {
       case tenDayAverageTradingVolume = "10DayAverageTradingVolume"
       case annualWeekHigh = "52WeekHigh"
       case annualWeekLow = "52WeekLow"
       case annualWeekLowDate = "52WeekLowDate"
       case annualWeekPriceReturnDaily = "52WeekPriceReturnDaily"
       case beta
    }
}
