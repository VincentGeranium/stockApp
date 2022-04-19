//
//  DateFormatter+.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/18.
//

import Foundation
import UIKit

extension DateFormatter {
    static let newsDateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    static let prettyDateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
