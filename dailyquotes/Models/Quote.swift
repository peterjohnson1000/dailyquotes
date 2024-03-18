//
//  Quote.swift
//  dailyquotes
//
//  Created by Peter Johnson on 3/18/24.
//

import Foundation

struct QuoteCategory: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    let name: String
    var isSelected: Bool
    let allQuotes: [Quote]
}

struct Quote: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var quote: String
    var author: String
}
