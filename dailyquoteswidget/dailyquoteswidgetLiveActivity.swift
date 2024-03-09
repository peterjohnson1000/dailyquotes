//
//  dailyquoteswidgetLiveActivity.swift
//  dailyquoteswidget
//
//  Created by Peter Johnson on 3/9/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct dailyquoteswidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct dailyquoteswidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: dailyquoteswidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension dailyquoteswidgetAttributes {
    fileprivate static var preview: dailyquoteswidgetAttributes {
        dailyquoteswidgetAttributes(name: "World")
    }
}

extension dailyquoteswidgetAttributes.ContentState {
    fileprivate static var smiley: dailyquoteswidgetAttributes.ContentState {
        dailyquoteswidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: dailyquoteswidgetAttributes.ContentState {
         dailyquoteswidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: dailyquoteswidgetAttributes.preview) {
   dailyquoteswidgetLiveActivity()
} contentStates: {
    dailyquoteswidgetAttributes.ContentState.smiley
    dailyquoteswidgetAttributes.ContentState.starEyes
}
