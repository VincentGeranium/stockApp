//
//  String+.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/19.
//

import Foundation
import UIKit

extension String {
    static func string(form timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.prettyDateFormatter.string(from: date)
    }
}
