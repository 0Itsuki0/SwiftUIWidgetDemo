//
//  DeepLinkProvider.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/17.
//


import SwiftUI
import WidgetKit

struct DeepLinkEntry: TimelineEntry {
    let date: Date
    var colors: [MyColor] = [MyColor(), MyColor(), MyColor()]
}

struct DeepLinkProvider: TimelineProvider {
    private let placeholderEntry = DeepLinkEntry(date: Date(), colors: [MyColor(r: 0, g: 0, b: 0, a: 0), MyColor(r: 0, g: 0, b: 0, a: 0), MyColor(r: 0, g: 0, b: 0, a: 0)])
   
    func placeholder(in context: Context) -> DeepLinkEntry {
        placeholderEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (DeepLinkEntry) -> ()) {
        completion(placeholderEntry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DeepLinkEntry>) -> ()) {
        let timeline = Timeline(entries: [DeepLinkEntry(date: Date())], policy: .never)
        completion(timeline)
    }
    
}
