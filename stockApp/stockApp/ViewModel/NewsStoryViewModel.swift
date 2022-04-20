//
//  NewsStoryViewModel.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/20.
//

import Foundation
import UIKit

struct NewsStoryViewModel {
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
