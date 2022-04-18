//
//  NewsStory.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/18.
//

import Foundation

struct NewsStroy: Codable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let id: Int
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
}
