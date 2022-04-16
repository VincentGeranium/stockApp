//
//  SearchResponse.swift
//  stockApp
//
//  Created by Kwangjun Kim on 2022/04/17.
//

import Foundation

struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}


struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
