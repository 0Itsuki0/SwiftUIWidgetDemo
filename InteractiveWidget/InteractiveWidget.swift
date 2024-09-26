//
//  InteractiveWidget.swift
//  InteractiveWidget
//
//  Created by Itsuki on 2024/09/19.
//

import WidgetKit
import SwiftUI

struct InteractiveWidgetView : View {
    var entry: InteractiveEntry
        
    var body: some View {
        VStack(spacing: 16) {
            Text("My Counter")

            HStack(spacing: 16) {
                Image(systemName: "heart.fill")
                Text("\(entry.count)")
                    .contentTransition(.numericText())
                Image(systemName: "heart.fill")
            }
            
            HStack(spacing: 32) {
                Button(intent: IncrementIntent(), label: {
                    Image(systemName: "plus")
                })
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(RoundedRectangle(cornerRadius: 8).fill(.black))
                
                Button(intent: ResetIntent(), label: {
                    Image(systemName: "arrow.counterclockwise")
                })
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(RoundedRectangle(cornerRadius: 8).fill(.black))
                
            }
        }
        .containerBackground(for: .widget) {
            Color.gray.opacity(0.3)
        }
        .widgetURL(URL(string: "\(WidgetScheme.interactiveWidget):///"))
    }
}

struct InteractiveWidget: Widget {
    let kind: String = WidgetKind.interactiveWidget

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: InteractiveProvider(), content: { entry in
            InteractiveWidgetView(entry: entry)
        })
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


#Preview(as: .systemSmall) {
    InteractiveWidget()
} timeline: {
    InteractiveEntry(date: Date(), count: 100)
}
