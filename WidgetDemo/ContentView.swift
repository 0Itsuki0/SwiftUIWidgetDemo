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
    @State private var path = NavigationPath()

    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                WrapperView() {
                    Text("Add a widget and Tap on it!")
                    VStack(spacing: 24) {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("SF Symbol Widget")
                        }
                        HStack {
                            Image(systemName: "star.fill")
                            Text("Deep Link Widget")
                        }
                        HStack {
                            Image(systemName: "star.fill")
                            Text("Interactive Widget")
                        }
                    }
                }
                
            }
            .onOpenURL { url in
                self.url = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.url = url
                }
            }
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
        WidgetCenter.shared.reloadTimelines(ofKind: TimelineKind.deepLinkWidget)

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
    
}

#Preview {
    ContentView(url: nil)
}
