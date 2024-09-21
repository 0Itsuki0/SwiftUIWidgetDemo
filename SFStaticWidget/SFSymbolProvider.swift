//
//  TimelineModel.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/16.
//

import SwiftUI
import WidgetKit

struct SFSymbolEntry: TimelineEntry {
    let date: Date
    let symbolName: String
}


struct SFSymbolProvider: TimelineProvider{
    private let placeholderEntry = SFSymbolEntry(date: Date(), symbolName: SFSymbol.heart)

    func placeholder(in context: Context) -> SFSymbolEntry {
        placeholderEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (SFSymbolEntry) -> ()) {
        completion(placeholderEntry)
    }

    // define each entry ahead of time
    func getTimeline(in context: Context, completion: @escaping (Timeline<SFSymbolEntry>) -> ()) {
        var entries: [SFSymbolEntry] = []

        // Generate a timeline consisting of 60 entries a second apart, starting from the current date.
        let currentDate = Date()

        for offset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .second, value: offset, to: currentDate)!
            let index = offset % 10;
            let entry = SFSymbolEntry(date: entryDate, symbolName: SFSymbol.list[index])
            entries.append(entry)
        }

        // Create the timeline with the entry and a reload policy that requests a new timeline after
        // the last date in the timeline passes.
        let timeline = Timeline(entries: entries, policy: .atEnd)

        completion(timeline)
    }

    // request every time: Great for render widget that need dynamic data (example: server side fetching)
//    func getTimeline(in context: Context, completion: @escaping (Timeline<SFSymbolEntry>) -> ()) {
//
//        // Create a timeline entry for "now."
//        let currentDate = Date()
//        let second = Calendar.current.component(.second, from: currentDate)
//        let index = second % 10
//        let entry = SFSymbolEntry(date: currentDate, symbolName: SFSymbol.list[index])
//
//        // Create a date that's 1 seconds in the future.
//        let nextUpdateDate = Calendar.current.date(byAdding: .second, value: 61, to: currentDate)!
//        print(nextUpdateDate)
//        // Create the timeline with the entry and a reload policy with the date
//        // for the next update.
//        let timeline = Timeline(
//            entries:[entry],
//            policy: .after(nextUpdateDate)
//        )
//
//        completion(timeline)
//    }
}
