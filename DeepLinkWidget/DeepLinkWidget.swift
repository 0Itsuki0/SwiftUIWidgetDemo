//
//  DeepLinkWidget.swift
//  DeepLinkWidget
//
//  Created by Itsuki on 2024/09/17.
//

import WidgetKit
import SwiftUI


struct DeepLinkWidgetEntryView : View {
    var entry: DeepLinkEntry

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "heart.fill")
                Text("Secret Color")
                Image(systemName: "heart.fill")
            }
            
            HStack(spacing: 24) {
                ForEach(0..<entry.colors.count, id: \.self) { index in
                    let color = entry.colors[index]
                    let uiColor = UIColor.rgba(color.r, color.g, color.b, CGFloat(color.a)/255)
                    Link(destination: MyColor.url(entry.colors, selectedIndex: index), label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(uiColor: uiColor))
                            .stroke(.black.opacity(0.3), style: .init(lineWidth: 1))
                    })
                }
            }
            
            HStack {
                Text("\(entry.date.formatted(date: .abbreviated, time: .omitted))")
                Text("\(entry.date.formatted(date: .omitted, time: .standard))")
            }
        }
        .padding(.horizontal, 24)
        .containerBackground(for: .widget) {
            Color.gray.opacity(0.3)
        }
        .widgetURL(MyColor.url(entry.colors, selectedIndex: nil))
    }
}

struct DeepLinkWidget: Widget {
    let kind: String = WidgetKind.deepLinkWidget

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DeepLinkProvider()) { entry in
            DeepLinkWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("DeepLinkWidget")
        .description("Widget Linking to specific app scenes.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    DeepLinkWidget()
} timeline: {
    DeepLinkEntry(date: Date())
}
