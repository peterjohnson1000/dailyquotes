//
//  ContentView.swift
//  dailyquotes
//
//  Created by Peter Johnson on 3/6/24.
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
}


struct ContentView: View {
    
    @State var categories: [QuoteCategory] = []
    
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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { data in
                    NavigationLink(value: data)
                    {
                        Text(data.name)
                    }
                }
            }
            .navigationTitle("Quotes Category")
            .navigationDestination(for: QuoteCategory.self) {data in
                MotivationalView(quotes: data)
            }
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
            ForEach(quotes.allQuotes) {eachQuote in
                NavigationLink(value: eachQuote)
                {
                    Text(eachQuote.quote)
                        .lineLimit(1)
                }
            }
        }
        .navigationDestination(for: Quote.self) {data in
            DetailedQuoteView(quotes: data)
        }
    }
}

struct DetailedQuoteView: View {
    let quotes: Quote
    var body: some View {
        Text(quotes.quote)
    }
}

#Preview {
    ContentView()
}
