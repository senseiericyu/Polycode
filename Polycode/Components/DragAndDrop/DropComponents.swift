//
//  DropComponents.swift
//  Polycode
//
//  Created by Mia Yang on 4/22/25.
//

import SwiftUI

//MARK: the answer components fro the Token (DnD) Questions
struct DropComponents: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var value: String
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 19
    var isShowing: Bool = false
}

var dropcomponents_: [DropComponents] = [
    DropComponents(value: "def"),
    DropComponents(value: "ten"),
    DropComponents(value: "("),
    DropComponents(value: ")"),
    DropComponents(value: ":"),
    DropComponents(value: "return"),
    DropComponents(value: "10")
]

