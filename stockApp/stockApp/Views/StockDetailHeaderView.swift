//
//  StockDetailHeaderView.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/21.
//

import Foundation
import UIKit

class StockDetailHeaderView: UIView {
    // MARK: - Properties
    private var metricViewModels: [MetricViewModel] = []
    
    // Chart view
    private let chartView: StockChartView = StockChartView()
    
    // CollectionView
        // collection view represent particular Financial data and chart view
        //  why did I create collection view? -> for the created horizontal layout
    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MetricCollectionViewCell.self, forCellWithReuseIdentifier: MetricCollectionViewCell.identifier)
        // Register cell
        return collectionView
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.collectionView.backgroundColor = .systemBackground
        clipsToBounds = true
        addSubViews(views: chartView, collectionView)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setupChartViewLayout()
        setupCollectionViewLayout()
    }
    
    func configure(chartViewModel: StockChartViewModel, metricViewModels: [MetricViewModel]) {
        // Update Chart
        
        self.metricViewModels = metricViewModels
        collectionView.reloadData()
    }
}

// MARK: - extension UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension StockDetailHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metricViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let viewModel = metricViewModels[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCollectionViewCell.identifier, for: indexPath) as? MetricCollectionViewCell else {
            fatalError()
        }
        
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width/2, height: 100/3)
    }
}

// MARK: - Private
private extension StockDetailHeaderView {
    private func setupChartViewLayout() {
        chartView.frame = CGRect(x: 0, y: 0, width: width, height: height-100)
    }
    
    private func setupCollectionViewLayout() {
        collectionView.frame = CGRect(x: 0, y: height-100, width: width, height: 100)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
