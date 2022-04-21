//
//  WatchListTableViewCell.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/20.
//

import Foundation
import UIKit

// Delegate for the cell
protocol WatchListTableViewCellDelegate: AnyObject {
    func didUpdateMaxWidth()
}

class WatchListTableViewCell: UITableViewCell {
    static let identifier: String = "WatchListTableViewCell"
    
    static let preferredHeight: CGFloat = 60
    
    // symbol label
    private let symbolLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    // company label
    private let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()

    // minichart label
    private let miniChartView: StockChartView = {
        let chartView: StockChartView = StockChartView()
        chartView.isUserInteractionEnabled = false
        chartView.clipsToBounds = true
        
        return chartView
    }()
    
    // price label
    private let priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    // change in price label
    private let changeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    weak var delegate: WatchListTableViewCellDelegate?
    
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
        contentView.clipsToBounds = true
        setupLayout()
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
        miniChartView.configure(with: viewModel.chartViewModel)
    }
}

// MARK: - Private
private extension WatchListTableViewCell {
    
    private func setupLayout() {
        symbolLabel.sizeToFit()
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        changeLabel.sizeToFit()
        
        let yStart: CGFloat = (contentView.height - symbolLabel.height - nameLabel.height) / 2
        
        let currentWidth = max(max(priceLabel.width, changeLabel.width), WatchListViewController.maxChangeWidth)
        
        if currentWidth > WatchListViewController.maxChangeWidth {
            WatchListViewController.maxChangeWidth = currentWidth
            delegate?.didUpdateMaxWidth()
        }
        
        symbolLabel.frame = CGRect(
            x: separatorInset.left,
            y: yStart,
            width: symbolLabel.width,
            height: symbolLabel.height
        )
        
        nameLabel.frame = CGRect(
            x: separatorInset.left,
            y: symbolLabel.bottom,
            width: nameLabel.width,
            height: nameLabel.height
        )
        
        priceLabel.frame = CGRect(
            x: contentView.width - 10 - currentWidth,
            y: (contentView.height - priceLabel.height - changeLabel.height) / 2,
            width: currentWidth,
            height: priceLabel.height
        )
        
        changeLabel.frame = CGRect(
            x: contentView.width - 10 - currentWidth,
            y: priceLabel.bottom,
            width: currentWidth,
            height: changeLabel.height
        )
        
        miniChartView.frame = CGRect(
            x: priceLabel.left - (contentView.width/3) - 5,
            y: 6,
            width: contentView.width/3,
            height: contentView.height-12
        )
    }
}
