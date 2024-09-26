//
//  ColorContentView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/18.
//


import SwiftUI
import WidgetKit

struct ColorContentView: View {
    @State var uiColors: [UIColor] = []
    @State var selectedColor: UIColor?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        WrapperView {
            if uiColors.isEmpty {
                Text("Tap on the Deep Link Widget to find out your secret color!")
                    .multilineTextAlignment(.center)
                    .lineSpacing(16.0)
            } else {
                VStack(spacing: 16) {
                    Text("Your Secret Colors")
                        .font(.title2)
                    Text("Tap on it to find out more!")
                }
                
                HStack(spacing: 32) {
                    ForEach(0..<uiColors.count, id: \.self) { index in
                        let uiColor = uiColors[index]

                        NavigationLink(destination: {
                            SingleColorView(uiColor: uiColor)
                        }, label: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(uiColor: uiColor))
                                .stroke(.black.opacity(0.3), style: .init(lineWidth: 2))
                                .frame(width: 80, height: 80)
                        })

                    }
                }

            }
        }
        .navigationDestination(item: $selectedColor, destination: { color in
            SingleColorView(uiColor: color)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading, content: {
            BackButton(action: {
                dismiss()
            })
        })
    }
    
    private func emojiStack() -> some View {
        return HStack {
            ForEach(0..<8) { _ in
                Text("🤩")
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        ColorContentView(url: URL(string: "mycolors:///255/255/255/0")!)
//    }
//}
