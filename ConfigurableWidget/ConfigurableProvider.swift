//
//  ConfigurableProvider.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/21.
//

import SwiftUI
import WidgetKit

struct FavoriteSymbolEntry: TimelineEntry {
    var date: Date
    var name: String
    var customize: Bool
    var color: ColorOption
    var size: SymbolSize
}

struct FavoriteSymbolProvider: AppIntentTimelineProvider {
    private let placeholderEntry = FavoriteSymbolEntry(
        date: Date(),
        name: SFSymbol.heart,
        customize: true,
        color: .red,
        size: .medium
    )
    
    func placeholder(in context: Context) -> FavoriteSymbolEntry {
        placeholderEntry
    }
    
    func snapshot(for configuration: FavoriteSymbolConfigurationIntent, in context: Context) async -> FavoriteSymbolEntry {
        return FavoriteSymbolEntry(
            date: Date(),
            name: configuration.name ?? SFSymbol.heart,
            customize: configuration.customize,
            color: configuration.customize ? configuration.color : .black,
            size: configuration.customize ? configuration.size ?? .medium : .medium
        )
    }
    
    func timeline(for configuration: FavoriteSymbolConfigurationIntent, in context: Context) async -> Timeline<FavoriteSymbolEntry> {
        
        let entry = FavoriteSymbolEntry(
            date: Date(),
            name: configuration.name ?? SFSymbol.heart,
            customize: configuration.customize,
            color: configuration.customize ? configuration.color : .black,
            size: configuration.customize ? configuration.size ?? .medium : .medium
        )
        
        let timeline = Timeline(
            entries: [entry],
            policy: .never
        )
        
        return timeline

    }
}
