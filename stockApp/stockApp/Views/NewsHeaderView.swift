//
//  NewsHeaderView.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/18.
//

import Foundation
import UIKit

protocol NewsHeaderViewDelegate: AnyObject {
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView)
}

class NewsHeaderView: UITableViewHeaderFooterView {
    // MARK: - Reusable Components
    // identifier property
    static let identifier: String = "NewsHeaderView"
    // use for header height
    static let preferredHeight: CGFloat = 70
    // delegate
    weak var delegate: NewsHeaderViewDelegate?
    
    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let button: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("+ Watchlist", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        return button
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubViews(views: label, button)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLabel()
        setupButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    public func configure(with viewModel: NewsHeaderViewModel) {
        label.text = viewModel.title
        button.isHidden = !viewModel.shouldShowAddButton
    }
    
    @objc func didTapButton() {
        // Call delegate
        delegate?.newsHeaderViewDidTapAddButton(self)
    }
}

// MARK: - Private
private extension NewsHeaderView {
    private func setupLabel() {
        label.frame = CGRect(
            x: 14,
            y: 0,
            width: contentView.width-28,
            height: contentView.height
        )
    }
    
    private func setupButton() {
        button.sizeToFit()
        button.frame = CGRect(
            x: contentView.width - button.width - 14,
            y: (contentView.height - button.height)/2,
            width: button.width + 8,
            height: button.height
        )
    }
}
