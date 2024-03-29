//
//  UIView+.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/16.
//

import Foundation
import UIKit
// MARK: - Adding Sub views
extension UIView {
    func addSubViews(views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}

// MARK: - Framing
extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var bottom: CGFloat {
        return top + height
    }
}
