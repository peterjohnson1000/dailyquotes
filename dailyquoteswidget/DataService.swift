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
//        loadJSONData()
        decodeJSONData()
    }
    
    func cat() -> String {
        return userCategorySelection
    }
    
    func pickRandomQuote(lengthOfAllQuotes: Int) -> Int {
        let randomQuote = Int.random(in: 0..<lengthOfAllQuotes)
        return randomQuote
    }
    
    // if reading data from a separate JSON file the below code can be used.
    func loadJSONData() {
        if let url = Bundle(for: type(of: self)).url(forResource: "quotes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                self.categories = try JSONDecoder().decode([QuoteCategory].self, from: data)
            }
            catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
    
    func decodeJSONData() {
        guard 
            let decodedData = UserDefaults(suiteName: "group.de.test.dailyquotes")?.data(forKey: "fullData"),
            let fullData = try? JSONDecoder().decode([QuoteCategory].self, from: decodedData)
        else { return }
        
        self.categories = fullData
    }

}
