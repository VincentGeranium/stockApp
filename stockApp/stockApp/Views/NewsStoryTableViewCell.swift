//
//  NewsStoryTableViewCell.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/18.
//

import Foundation
import UIKit
import SDWebImage

class NewsStoryTableViewCell: UITableViewCell {
    struct ViewModel {
        let source: String
        let headline: String
        let dateString: String
        let imageUrl: URL?
        
        // Important business logic :  ViewModel from the Model
        // ViewModel will be a drive the object from the Model
        init(model: NewsStroy) {
            self.source = model.source
            self.headline = model.headline
            self.dateString = .string(form: model.datetime)
            self.imageUrl = URL(string: model.image)
        }
    }
    
    // Source
    let sourceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        
        return label
    }()
    
    // Headline
    let headLineLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.numberOfLines = 0
        
        return label
    }()
    
    // Date
    let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .light)
        
        return label
    }()
    
    // Image
    private let storyImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 7
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    static let preferredHeight: CGFloat = 140
    
    static let identifier: String = "NewsStoryTableViewCell"
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = nil
        self.backgroundColor = nil
        self.addSubViews(views: sourceLabel, headLineLabel, dateLabel, storyImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height - 6
        storyImageView.frame = CGRect(
            x: contentView.width-imageSize-10,
            y: 3,
            width: imageSize,
            height: imageSize
        )
        
        // Layout labels
        let availablewidth: CGFloat = contentView.width - separatorInset.left - imageSize - 15
        
        dateLabel.frame = CGRect(
            x: separatorInset.left,
            y: contentView.height - 40,
            width: availablewidth,
            height: 40
        )
        
        sourceLabel.sizeToFit()
        sourceLabel.frame = CGRect(
            x: separatorInset.left,
            y: 4,
            width: availablewidth,
            height: sourceLabel.height
        )
        
        headLineLabel.frame = CGRect(
            x: separatorInset.left,
            y: sourceLabel.bottom + 5,
            width: availablewidth,
            height: contentView.height - sourceLabel.bottom - dateLabel.height - 10
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        headLineLabel.text = nil
        dateLabel.text = nil
        storyImageView.image = nil
    }
    
    // MARK: - Public
    public func configure(viewModel: ViewModel) {
        sourceLabel.text = viewModel.source
        headLineLabel.text = viewModel.headline
        dateLabel.text = viewModel.dateString
        storyImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        
        // Manually set image
        //storyImageView.setImage(with: viewModel.imageUrl)
    }
}
