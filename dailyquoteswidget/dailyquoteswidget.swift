//
//  dailyquoteswidget.swift
//  dailyquoteswidget
//
//  Created by Peter Johnson on 3/9/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    let data = DataService()
    
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date(), myString: data.cat(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> DayEntry {
        DayEntry(date: Date(), myString: data.cat(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<DayEntry> {
        var entries: [DayEntry] = []

        // Get the current date
        let currentDate = Date()
        
        // Get the start of the current day (midnight)
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        
        // Create an entry for midnight of the current day
        let entryDate = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        let entry = DayEntry(date: entryDate, myString: data.cat(), configuration: configuration)
        entries.append(entry)

        // Return the timeline with a single entry for the next midnight
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
    let myString: String
    let configuration: ConfigurationAppIntent
}

struct dailyquoteswidgetEntryView : View {
    var entry: DayEntry
    let data = DataService()

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(.black)
            VStack(alignment:.trailing) {
                ForEach(data.categories) { category in
                    if category.name == data.cat()
                    {
                        let randomQuoteIndex = data.pickRandomQuote(lengthOfAllQuotes: category.allQuotes.count)
                        
                        Text("\(category.allQuotes[randomQuoteIndex].quote)")
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom,5)
                        
                        Text("~ \(category.allQuotes[randomQuoteIndex].author)")
                            .foregroundStyle(.white)
                            .fontWeight(.light)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            // Trigger data update when the widget appears
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

struct dailyquoteswidget: Widget {
    let kind: String = "dailyquoteswidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            dailyquoteswidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemMedium) {
    dailyquoteswidget()
} timeline: {
    DayEntry(date: .now, myString: "test", configuration: .smiley)
    DayEntry(date: .now, myString: "test", configuration: .starEyes)
}
