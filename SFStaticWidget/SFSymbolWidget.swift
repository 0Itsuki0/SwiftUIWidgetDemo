//
//  SFSymbolWidget.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/16.
//

import SwiftUI
import WidgetKit

struct SFSymbolWidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily

    var entry: SFSymbolEntry
    
    var body: some View {
        let emojiStack = emojiStack()
        VStack(spacing: 24) {
            if (widgetFamily == .systemLarge || widgetFamily == .systemExtraLarge) {
                emojiStack
            }
            
            if (widgetFamily == .systemSmall) {
                Text("Hello!")
            } else {
                Text("Have a nice day!")
            }
            HStack(spacing: 16) {
                Image(systemName: entry.symbolName)
                VStack(alignment: .leading, spacing: 16) {
                    switch widgetFamily{
                    case .systemSmall:
                        Text("\(entry.date.formatted(date: .omitted, time: .shortened))")
                        
                    case .systemMedium:
                        Text("\(entry.date.formatted(date: .abbreviated, time: .shortened))")
                        
                    case .systemLarge:
                        Text("\(entry.date.formatted(date: .long, time: .omitted))")
                        Text("\(entry.date.formatted(date: .omitted, time: .standard))")

                    case .systemExtraLarge:
                        Text("\(entry.date.formatted(date: .omitted, time: .shortened))")
                        
                    default:
                        Color.clear
                    }

                }
            }
            
            if (widgetFamily == .systemLarge || widgetFamily == .systemExtraLarge) {
                emojiStack
            }
            
        }
        .containerBackground(for: .widget) {
            if widgetFamily == .systemSmall {
                Color.red.opacity(0.2)
            } else {
                VStack {
                    HStack {
                        Image(systemName: entry.symbolName)
                        Spacer()
                        Image(systemName: entry.symbolName)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: entry.symbolName)
                        Spacer()
                        Image(systemName: entry.symbolName)
                    }

                }
                .padding(.all, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red.opacity(0.2))
            }
        }
        .widgetURL(URL(string: "\(WidgetScheme.sfSymbolWidget):///"))
    }
    
    private func emojiStack() -> some View {
        return HStack {
            ForEach(0..<8) { _ in
                Text("🤩")
            }
        }
    }
}


struct SFSymbolWidget: Widget {
    let kind: String = TimelineKind.sfSymbolWidget

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SFSymbolProvider()) { entry in
            SFSymbolWidgetView(entry: entry)

        }
        .description("SFSymbol Widget with current time!")
        .configurationDisplayName("SFSymbol Widget")
        .supportedFamilies([.systemSmall,.systemMedium, .systemLarge, .systemExtraLarge])
    }
}




#Preview(as: .systemMedium) {
    SFSymbolWidget()
} timeline: {
    SFSymbolEntry(date: Date(), symbolName: SFSymbol.heart)
}
