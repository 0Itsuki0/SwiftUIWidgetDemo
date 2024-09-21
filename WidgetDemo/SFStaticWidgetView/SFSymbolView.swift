//
//  SFStaticContentView.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/20.
//

import SwiftUI

struct SFSymbolView: View {
    let columns = Array.init(repeating: GridItem(.fixed(40), spacing: 16), count: 5)
    private let symbols = SFSymbol.list
    var body: some View {
        WrapperView() {
            Text("Here are the symbols!\nWhich one did you get?")
                .multilineTextAlignment(.center)
                .lineSpacing(16.0)
            
            Spacer()
                .frame(height: 16.0)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(symbols, id: \.self) { symbol in
                    Image(systemName: symbol)
                }
            }
            
            Spacer()
                .frame(height: 16.0)
            
            Text("Have a nice day!")

        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    SFSymbolView()
}
