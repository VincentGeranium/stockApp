//
//  StockChartView.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/20.
//

import Foundation
import UIKit
import Charts

class StockChartView: UIView {
    // MARK: - Properties
    private let chartView: LineChartView = {
        let chartView: LineChartView = LineChartView()
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(true)
        chartView.xAxis.enabled = false
        chartView.legend.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        
        return chartView
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChartView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setupChartViewLyout()
    }
    
    // Reset the chart view
    func reset() {
        chartView.data = nil
    }
    
    func configure(with viewModel: StockChartViewModel) {
        var entries: [ChartDataEntry] = []
        
        for (index, value) in viewModel.data.enumerated() {
            entries.append(.init(x: Double(index), y: value))
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "Some label")
        dataSet.fillColor = .systemBlue
        dataSet.drawFilledEnabled = true
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
}

private extension StockChartView {
    private func setupChartView() {
        self.addSubview(chartView)
    }
    
    private func setupChartViewLyout() {
        chartView.frame = self.bounds
    }
}
