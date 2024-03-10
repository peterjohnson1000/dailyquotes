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
    let allQuotes: [Quote]
}

struct Quote: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var quote: String
    var author: String
}


struct ContentView: View {
    
    @State var categories: [QuoteCategory] = []
//    @AppStorage var userCategorySelection: String
    @State var isCategorySelected: Bool = false
    
    func loadQuotes() {
        if let url = Bundle.main.url(forResource: "quotes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                self.categories = try JSONDecoder().decode([QuoteCategory].self, from: data)
                print(self.categories)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
    
// NavigationLink(value: category) was used for individual quote view
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { category in
                    HStack {
                        Text(category.name)
                        Spacer()
                        Image(systemName: isCategorySelected ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(isCategorySelected ? .green : .gray)
                            .onTapGesture {
                                isCategorySelected.toggle()
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
