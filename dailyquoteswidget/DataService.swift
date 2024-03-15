//
//  DataService.swift
//  dailyquoteswidgetExtension
//
//  Created by Peter Johnson on 3/12/24.
//

import Foundation
import SwiftUI

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

class DataService {
    
    var categories: [QuoteCategory] = []
    
    @AppStorage("userCategorySelection", store: UserDefaults(suiteName: "group.de.test.dailyquotes")) private var userCategorySelection: String = "Motivational"
    
    init() {
        loadJSONData()
    }
    
    func cat() -> String {
        loadJSONData()
        return userCategorySelection
    }
    
    func pickRandomQuote(lengthOfAllQuotes: Int) -> Int {
        let randomQuote = Int.random(in: 0..<lengthOfAllQuotes)
        return randomQuote
    }
    
    func loadJSONData() {
        if let url = Bundle(for: type(of: self)).url(forResource: "quotes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                self.categories = try JSONDecoder().decode([QuoteCategory].self, from: data)
                print("fkg data \(self.categories)")
            }
            catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
    
}
