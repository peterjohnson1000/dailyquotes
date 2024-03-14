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

struct Visitors: Codable {
    var count: Int
}


class DataService {
    @State private var categories: [QuoteCategory] = []
//    @State private var count: Visitors = Visitors(count: 0)
    var count: Int = 0
    
    @AppStorage("userCategorySelection", store: UserDefaults(suiteName: "group.de.test.dailyquotes")) private var userCategorySelection: String = "Motivational"
    
    // Initialize the DataService asynchronously
    init() {
        initializeAsync()
    }
    
    func initializeAsync() {
        print("hi")
         Task {
             do {
                 let url = URL(string: "")!
                 let (data, _) = try await URLSession.shared.data(from: url)
                 
                 if let responseString = String(data: data, encoding: .utf8), let count = Int(responseString) {
                     self.count = count
                     print("DataService initialized with count: \(self.count)")
                 } else {
                     print("Error: Invalid response format")
                 }
             } catch {
                 print("Error initializing DataService: \(error)")
             }
         }
     }
    
    func cat() -> Int {
        return count
    }
}
