//
//  WatchListViewModel.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/20.
//

import Foundation
import UIKit

// MARK: - ViewModel
struct WatchListViewModel {
    let symbol: String
    let companyName: String
    let price: String // formatted
    let changeColor: UIColor // red or green
    let changePercentage: String // formatted
//        let chartViewModel: StockChartView.ViewModel
}
