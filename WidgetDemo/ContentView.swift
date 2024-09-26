//
//  ContentView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/20.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var url: URL?
    @State var activity: NSUserActivity?
    @State var intent: FavoriteSymbolConfigurationIntent?
    
    @StateObject private var activityManager = ActivityManager()


    var body: some View {
        NavigationStack {
            ZStack {
                WrapperView() {
                    Text("Add a widget and Tap on it!")
                        .fontWeight(.bold)
                    VStack(spacing: 24) {
                        staredText("SF Symbol Widget")
                        staredText("Deep Link Widget")
                        staredText("Interactive Widget")
                        staredText("Configurable Widget")
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Text("Live Activity (Widget)!")
                        .fontWeight(.bold)
                    Text("Start a new one to check it out!")
                    Button(action: {
                        self.url = URL(string: "\(WidgetScheme.liveActivityWidget):///")
                    }, label: {
                        Text("GO →")
                            .fontWeight(.semibold)
                    })
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 8).fill())

                }
            }
            .onOpenURL { url in
                reset()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.url = url
                }
            }
            .onContinueUserActivity("\(FavoriteSymbolConfigurationIntent.self)", perform: { activity in
                reset()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.activity = activity
                }
            })
            .navigationDestination(item: $activity, destination: { activity in
                FavoriteConfigView(currentIntent: processConfigurableWidgetIntent(activity))
            })
            .navigationDestination(item: $url, destination: { url in
                if let scheme = url.scheme {
                    switch scheme {
                    case WidgetScheme.sfSymbolWidget:
                        SFSymbolView()
                    case WidgetScheme.deepLinkWidget:
                        let (colors, selectedColor) = processColorWidgetUrl(url)
                        ColorContentView(uiColors: colors, selectedColor: selectedColor)
                    case WidgetScheme.interactiveWidget:
                        CountertView()
                    case WidgetScheme.liveActivityWidget:
                        ActivityContentView(activityId: processLiveActivityUrl(url))
                            .environmentObject(activityManager)
                    default:
                        WrapperView() {
                            Text("Oops, unknown URL!")
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                self.url = nil
                            })
                        }
                    }
                }
            })
        }
    }
    
    private func processColorWidgetUrl(_ url: URL) -> ([UIColor], UIColor?) {
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.deepLinkWidget)

        let (colors, selectedIndex) = MyColor.colorsFromURL(url)
        let uiColors = colors.map({ color in
            color.uiColor
        })
        if let index = selectedIndex, index < colors.count {
            let selectedColor = uiColors[index]
            return (uiColors, selectedColor)
        }
        return (uiColors, nil)
    }
    
    private func processLiveActivityUrl(_ url: URL) -> String? {
        let pathComponents = url.pathComponents
        if pathComponents.count > 1 {
            return pathComponents[1]
        }
        return nil
    }
    
    private func processConfigurableWidgetIntent(_ activity: NSUserActivity) -> FavoriteSymbolConfigurationIntent? {
        let intent = activity.widgetConfigurationIntent(of: FavoriteSymbolConfigurationIntent.self)
        return intent
    }
    
    private func staredText(_ text: String) -> some View {
        HStack {
            Image(systemName: "star.fill")
            Text(text)
        }
    }
    
    private func reset() {
        self.url = nil
        self.activity = nil
    }
    
}

#Preview {
    ContentView(url: nil)
}
