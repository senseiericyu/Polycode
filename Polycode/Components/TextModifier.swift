//
//  TextModifier.swift
//  Polycode
//
//  Created by Eric Yu on 4/13/25.
//

import SwiftUI

struct PolyFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textCase(.uppercase)
            .fontWeight(.bold)
            .fontDesign(.rounded)
    }
}

extension View {
    func polyfont() -> some View {
        modifier(PolyFont())
    }
}
