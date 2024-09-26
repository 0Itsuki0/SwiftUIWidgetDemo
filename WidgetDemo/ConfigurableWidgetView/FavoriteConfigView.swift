//
//  FavoriteConfigView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/22.
//

import SwiftUI
import WidgetKit

struct FavoriteConfigView: View {
    var currentIntent: FavoriteSymbolConfigurationIntent?

    @State private var intentList: [FavoriteSymbolConfigurationIntent] = []
    
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        WrapperView {
            Text("Your Favorite SF Symbol!")

            Divider()
                .background(.black.opacity(0.8))
            
            VStack(spacing: 16) {
                Text("Current")
                if let currentIntent = currentIntent {
                    FavoriteSymbolCard(intent: currentIntent)
                } else {
                    Text("Not Found!")
                }
            }
            
            Divider()
                .background(.black.opacity(0.8))

                ScrollView(.horizontal, content: {
                    HStack(spacing: 0) {
                        ForEach(0..<intentList.count, id: \.self) { index in
                            FavoriteSymbolCard(intent: intentList[index])
                                .scaleEffect(0.9)
                        }
                    }
                })
                .scrollIndicators(.hidden)

        }
        .task {
            guard let configurations = try? await WidgetCenter.shared.currentConfigurations() else {return}
            var intents: [FavoriteSymbolConfigurationIntent] = []
            for configuration in configurations {
                if configuration.kind != WidgetKind.configurableWidget {continue}
                guard let intent = configuration.widgetConfigurationIntent(of: FavoriteSymbolConfigurationIntent.self) else {continue}
                intents.append(intent)
            }
            self.intentList = intents
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading, content: {
            BackButton(action: {
                dismiss()
            })
        })
    }
}

fileprivate struct FavoriteSymbolCard: View {
    var intent: FavoriteSymbolConfigurationIntent = FavoriteSymbolConfigurationIntent.init()

    var body: some View {
        
        Group {
            
            if let name = intent.name {
                let customize = intent.customize
                
                let width: CGFloat = customize ? CGFloat(intent.size?.width ?? SymbolSize.medium.width) : CGFloat(SymbolSize.medium.width)
                let height: CGFloat = customize ? CGFloat(intent.size?.height ?? SymbolSize.medium.height)  : CGFloat(SymbolSize.medium.height)
                
                let image = Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .foregroundStyle(customize ? intent.color.color : .black)

                VStack(spacing: 16) {
                    Text("name: \(name)")
                    Text("customized: \(intent.customize)")
                    if intent.customize {
                        Text("color: \(intent.color.rawValue)")
                        Text("size: \(intent.size?.id ?? "Not available")")

                    }
                }
                .padding(.horizontal, 48)
                .overlay(content: {
                    HStack {
                        symbolStack(image: image)
                        Spacer()
                        symbolStack(image: image)
                    }
                })

            } else {
                Text("Oops!\nUnknown Symbol!")
                    .multilineTextAlignment(.center)
                    .lineSpacing(16)
            }
        }
        .clipShape(Rectangle())
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).stroke(.black.opacity(0.8), style: .init(lineWidth:1.0)))
    }
    
    private func symbolStack<Content: View >(image: Content)-> some View {
        VStack(spacing: 12) {
            image
            image
            image
            image
            image
            image
        }
    }
}

