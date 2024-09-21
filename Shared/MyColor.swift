//
//  MyColor.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/17.
//

import SwiftUI

struct MyColor: Identifiable {
    var id: UUID = UUID()
    var r: Int = Int.random(in: 0..<256)
    var g: Int = Int.random(in: 0..<256)
    var b: Int = Int.random(in: 0..<256)
    var a: Int = Int.random(in: 0..<256)

}

extension MyColor {
    static let queryName = "index"
    
    var uiColor: UIColor {
        return UIColor.rgba(self.r, self.g, self.b, CGFloat(self.a)/255)
    }
    
    static func colorsFromURL(_ url: URL) -> ([MyColor], Int?){

        var colors: [MyColor] = []
        let pathComponents = url.pathComponents
        for i in stride(from: 1, to: pathComponents.count, by: 4) {
            guard let r = Int(pathComponents[i]),
                  let g = Int(pathComponents[i+1]),
                  let b = Int(pathComponents[i+2]),
                  let a = Int(pathComponents[i+3])
            else { continue }
            let color = MyColor(r: r, g: g, b: b, a: a)
            colors.append(color)
        }
        
        
        if let selectedIndexString = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == queryName })?.value, let selectedIndex = Int(selectedIndexString) {
            return (colors, selectedIndex)
        }
        
        return (colors, nil)
    }
    
    
    
    static func url(_ colors: [MyColor], selectedIndex: Int?) -> URL {
        var urlString = "\(WidgetScheme.deepLinkWidget):///"
        for color in colors {
            urlString = "\(urlString)/\(color.r)/\(color.g)/\(color.b)/\(color.a)"
        }
        if let selectedIndex = selectedIndex {
            urlString = "\(urlString)?\(queryName)=\(selectedIndex)"
        }
        return URL(string: urlString)!
    }
    
}
