//
//  SearchResultTableViewCell.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/16.
//

import Foundation
import UIKit

class SearchResultTableViewCell: UITableViewCell {
    static let identifier: String = "SearchResultTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
