//
//  QuoteDataModel.swift
//  dailyquotes
//
//  Created by Peter Johnson on 3/18/24.
//

import Foundation
import SwiftUI

class QuoteDataModel: ObservableObject {
    
    @Published var categories: [QuoteCategory] = []
    
    @AppStorage("userCategorySelection", store: UserDefaults(suiteName: "group.de.test.dailyquotes")) var userCategorySelection: String = "Motivational"
    
    init() {
        loadQuotes()
        startupCategoryDefaultSelector()
    }
    
    private func loadQuotes() {
        if let url = Bundle.main.url(forResource: "quotes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                self.categories = try JSONDecoder().decode([QuoteCategory].self, from: data)
                encodeJSONData()
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
    
    private func encodeJSONData() {
        if let encodedData = try? JSONEncoder().encode(categories) {
//            UserDefaults.standard.setValue(encodedData, forKey: "fullData")
            UserDefaults(suiteName: "group.de.test.dailyquotes")?.setValue(encodedData, forKey: "fullData")
            print("encodedData")
            print(encodedData)
        }
    }
    
    
    private func startupCategoryDefaultSelector() {
        if userCategorySelection.count > 0
        {
            for index in categories.indices {
                if categories[index].name == userCategorySelection
                {
                    categories[index].isSelected = true
                }
            }
        }
    }
    
    func update(index: Int) {
        categories[index].isSelected = true
        
        userCategorySelection = categories[index].name
    }
    
    
}
