//
//  InteractiveProvider.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/20.
//

import SwiftUI
import WidgetKit

struct InteractiveEntry: TimelineEntry {
    let date: Date
    let count: Int
}


struct InteractiveProvider: TimelineProvider {
    private let placeholderEntry = InteractiveEntry(date: Date(), count: 0)
   
    func placeholder(in context: Context) -> InteractiveEntry {
        placeholderEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (InteractiveEntry) -> ()) {
        completion(placeholderEntry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<InteractiveEntry>) -> ()) {
        let timeline = Timeline(entries: [InteractiveEntry(date: Date(), count: CountManager.currentCount)], policy: .never)
        completion(timeline)
    }
    
}
