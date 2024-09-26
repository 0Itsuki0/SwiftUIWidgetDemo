//
//  ConfigurationIntent.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/21.
//

import SwiftUI
import AppIntents


struct FavoriteSymbolConfigurationIntent: WidgetConfigurationIntent {
    
    init() {
        self.name = SFSymbol.heart
        self.customize = true
        self.color = .red
        self.size = .medium
    }
    
    static var title: LocalizedStringResource = "Favorite SF Symbol"
    static var description = IntentDescription("Display your favorite SF Symbol!")

    @Parameter(title: "Name", optionsProvider: SymbolNameOptionsProvider())
    var name: String?
    
    struct SymbolNameOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            return SFSymbol.list
        }
        
        func defaultResult() async -> String? {
            return SFSymbol.list.first
        }
    }
        
    @Parameter(title: "Customize", default: false)
    var customize: Bool

    @Parameter(title: "Color", default: .red)
    var color: ColorOption
    
    @Parameter(title: "Size", default: SymbolSize.medium)
    var size: SymbolSize?

    static var parameterSummary: some ParameterSummary {
        When(\.$customize, .equalTo, true) {
            Summary {
                \.$name
                \.$customize
                \.$color
                \.$size
            }
        } otherwise: {
            Summary {
                \.$name
                \.$customize
            }
        }
    }
}

enum ColorOption: String, AppEnum {
    case red, green, orange, blue, yellow, black
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Color"
    static var caseDisplayRepresentations: [ColorOption : DisplayRepresentation] = [
        .black: "Black",
        .red: "Red",
        .green: "Green",
        .orange: "Orange",
        .blue: "Blue",
        .yellow: "Yellow",
    ]
    
    var color: Color {
        switch self {
        case .black: return .black
        case .red: return .red
        case .green: return .green
        case .orange: return .orange
        case .blue: return .blue
        case .yellow: return .yellow
        }
    }
}

struct SymbolSize: AppEntity {
    
    let id: String
    
    let width: Int
    let height: Int
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Size"
    static var defaultQuery = SizeQuery()
            
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id): (\(width), \(height))")
    }
    
    static let small = SymbolSize(id: "Small", width: 12, height: 12)
    static let medium = SymbolSize(id: "Medium", width: 24, height: 24)
    static let large = SymbolSize(id: "Large", width: 36, height: 36)
    
    static let allSizes: [SymbolSize] = [ small, medium, large]
    
    struct SizeQuery: EntityQuery {
        func entities(for identifiers: [SymbolSize.ID]) async throws -> [SymbolSize] {
            SymbolSize.allSizes.filter { identifiers.contains($0.id) }
        }
        
        func suggestedEntities() async throws -> [SymbolSize] {
            SymbolSize.allSizes
        }
        
        func defaultResult() async -> SymbolSize? {
            try? await suggestedEntities().first
        }

    }
}
