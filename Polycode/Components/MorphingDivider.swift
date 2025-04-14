//
//  MorphingDivider.swift
//  Polycode
//
//  Created by Eric Yu on 4/14/25.
//

import SwiftUI

struct MorphingDividerShape: Shape {
    var morphValue: CGFloat
    let slantHeight: CGFloat = 4

    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        let leftOffset = max(0, -morphValue) * slantHeight
        let rightOffset = max(0, morphValue) * slantHeight

        var path = Path()
        path.move(to: CGPoint(x: 0, y: leftOffset))
        path.addLine(to: CGPoint(x: width, y: rightOffset))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()

        return path
    }

    var animatableData: CGFloat {
        get { morphValue }
        set { morphValue = newValue }
    }
}
