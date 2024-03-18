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
import WidgetKit

struct ContentView: View {
    
    @ObservedObject var allCategories = QuoteDataModel()
    
    @AppStorage("userCategorySelection", store: UserDefaults(suiteName: "group.de.test.dailyquotes")) var userCategorySelection: String = "Motivational"
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allCategories.categories.indices, id:\.self) { index in
                    let category = allCategories.categories[index]
                    HStack {
                        Text(category.name)
                        Spacer()
                        Image(systemName: category.isSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(category.isSelected ? .green : .gray)
                            .onTapGesture {
                                
                                allCategories.categories.indices.forEach { index in
                                    allCategories.categories[index].isSelected = false
                                }
                                
                                allCategories.update(index: index)
                                
                                WidgetCenter.shared.reloadTimelines(ofKind: "dailyquoteswidget")
                            }
                    }
                }
            }
            .navigationTitle("Quotes Category")
//            .navigationDestination(for: QuoteCategory.self) { currentCategoryData in
//                MotivationalView(quotes: currentCategoryData)
//            }
        }
//        .onAppear {
//            loadQuotes()
//        }
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
