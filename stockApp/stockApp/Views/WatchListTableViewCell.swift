//
//  WatchListTableViewCell.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/20.
//

import Foundation
import UIKit

class WatchListTableViewCell: UITableViewCell {
    static let identifier: String = "WatchListTableViewCell"
    
    static let preferredHeight: CGFloat = 60
    
    // symbol label
    private let symbolLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        
        return label
    }()
    
    // company label
    private let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()

    // minichart label
    private let miniChartView = StockChartView()
    
    // price label
    private let priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    // change in price label
    private let changeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubViews(views: symbolLabel, nameLabel, miniChartView, priceLabel, changeLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // For subviews layouts
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // For prepare cell to reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset()
    }
    
    // MARK: - Public
    // configure cell
    public func configure(with viewModel: WatchListViewModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
        // Configure chart
    }
}
