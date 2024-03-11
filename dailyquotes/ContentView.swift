//
//  ContentView.swift
//  dailyquotes
//
//  Created by Peter Johnson on 3/6/24.
//

// refactoring
// json struct and json loader
//

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


struct ContentView: View {
    
    @State var categories: [QuoteCategory] = []
    @AppStorage("userCategorySelection") var userCategorySelection: String = "Motivational"
    
    func loadQuotes() {
        if let url = Bundle.main.url(forResource: "quotes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                self.categories = try JSONDecoder().decode([QuoteCategory].self, from: data)
                print(self.categories)
                
                if userCategorySelection.count > 0
                {
                    for index in categories.indices {
                        if categories[index].name == userCategorySelection
                        {
                            categories[index].isSelected = true
                        }
                    }
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        print("User category selection: \(userCategorySelection)")
    }
    
// NavigationLink(value: category) was used for individual quote view
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories.indices, id:\.self) { index in
                    let category = categories[index]
                    HStack {
                        Text(category.name)
                        Spacer()
                        Image(systemName: category.isSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(category.isSelected ? .green : .gray)
                            .onTapGesture {
                                categories.indices.forEach { index in
                                    categories[index].isSelected = false
                                }
                                
                                categories[index].isSelected = true
                                
                                userCategorySelection = category.name
                            }
                    }
                }
            }
            .navigationTitle("Quotes Category")
//            .navigationDestination(for: QuoteCategory.self) { currentCategoryData in
//                MotivationalView(quotes: currentCategoryData)
//            }
        }
        .onAppear {
            loadQuotes()
        }
    }
}

struct MotivationalView: View {
    let quotes: QuoteCategory
    var body: some View {
        List {
            ForEach(quotes.allQuotes) { eachQuote in
                    VStack(alignment: .trailing) {
                        Text("\"\(eachQuote.quote)\"")
                        Text("- \(eachQuote.author)")
                    }
                    .navigationBarTitleDisplayMode(.inline)
            }
            .padding(.vertical,5)
        }
    }
}

#Preview {
    ContentView()
}
