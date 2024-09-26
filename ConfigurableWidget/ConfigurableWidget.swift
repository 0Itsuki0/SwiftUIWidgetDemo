//
//  ConfigurableWidget.swift
//  ConfigurableWidget
//
//  Created by Itsuki on 2024/09/21.
//

import WidgetKit
import SwiftUI

struct ConfigurableWidgetView : View {
    @Environment(\.widgetFamily) var widgetFamily

    var entry: FavoriteSymbolEntry
    private let spacing = 4.0
    
    var body: some View {
        let width: CGFloat = CGFloat(entry.size.width)
        let height: CGFloat = CGFloat(entry.size.height)
        let columns = Array(repeating: GridItem(.fixed(width), spacing: spacing), count: 10)
        let maskSize: CGFloat = switch widgetFamily {
        case .systemSmall:
            136
        case .systemMedium:
            152
        case .systemLarge:
            300
        default:
            120
        }
        
        let maskPadding: CGFloat = switch widgetFamily {
        case .systemLarge:
            16
        default:
            8
        }
        
        
        VStack(spacing: 16) {
            LazyVGrid(columns: columns, spacing: spacing, content: {
                ForEach(0..<100) { _ in
                    Image(systemName: entry.name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: height)
                        .foregroundStyle(entry.color.color)
                }
            })
            .mask(
                Image(systemName: "heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: maskSize, height: maskSize)
                    
            )
            .overlay(content: {
                Image(systemName: "heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: maskSize+maskPadding, height: maskSize+maskPadding)
                    .fontWeight(.ultraLight)
                    .foregroundStyle(entry.color.color)
            })
        }
        .containerBackground(for: .widget) {
            entry.color.color.opacity(0.2)
        }
    }
}

struct ConfigurableWidget: Widget {
    let kind: String = WidgetKind.configurableWidget

    var body: some WidgetConfiguration {
            AppIntentConfiguration(
                kind: kind,
                intent: FavoriteSymbolConfigurationIntent.self,
                provider: FavoriteSymbolProvider()) { entry in
                    ConfigurableWidgetView(entry: entry)
            }
            .configurationDisplayName("Favorite Symbol")
            .description("Displays your favorite SF Symbol")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        }
}

#Preview(as: .systemMedium) {
    ConfigurableWidget()
} timeline: {
    FavoriteSymbolEntry(
        date: Date(),
        name: SFSymbol.heart,
        customize: true,
        color: .black,
        size: .medium
    )
}
