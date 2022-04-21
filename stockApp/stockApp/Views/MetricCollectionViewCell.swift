//
//  MetricCollectionViewCell.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/21.
//

import Foundation
import UIKit

class MetricCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier: String = "MetricCollectionViewCell"
    
    private let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.clipsToBounds = true
        contentView.addSubViews(views: nameLabel, valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    /// layout all the properties of subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        setupNameLabelLayout()
        setupValueLabelLayout()
        
    }
    
    /// prepare cell for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
    func configure(with viewModel: MetricViewModel) {
        nameLabel.text = viewModel.name+":"
        valueLabel.text = viewModel.value
    }
}

// MARK: - Private
private extension MetricCollectionViewCell {
    private func setupNameLabelLayout() {
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(
            x: 3,
            y: 0,
            width: nameLabel.width,
            height: contentView.height
        )
    }
    
    private func setupValueLabelLayout() {
        valueLabel.sizeToFit()
        valueLabel.frame = CGRect(
            x: nameLabel.right + 3,
            y: 0,
            width: valueLabel.width,
            height: contentView.height
        )
    }
}
