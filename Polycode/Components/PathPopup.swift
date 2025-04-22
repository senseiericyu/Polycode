//
//  TailPopup.swift
//  Polycode
//
//  Created by Eric Yu on 4/15/25.
//

import SwiftUI

// MARK: - combining the shapes for rendering purposes

struct TailBubble: Shape {
    var cornerRadius: CGFloat = 16
    var triangleSize: CGSize = CGSize(width: 30, height: 15)
    var triangleOffset: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let bubbleY = triangleSize.height
        let bubbleRect = CGRect(x: 0, y: bubbleY, width: rect.width, height: rect.height - bubbleY)

        var path = Path()

        // body
        let rounded = UIBezierPath(
            roundedRect: bubbleRect,
            byRoundingCorners: [.allCorners],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        path.addPath(Path(rounded.cgPath))

        // tail
        let triangleX = rect.midX + triangleOffset
        path.move(to: CGPoint(x: triangleX - triangleSize.width / 2, y: bubbleY))
        path.addLine(to: CGPoint(x: triangleX, y: 0))
        path.addLine(to: CGPoint(x: triangleX + triangleSize.width / 2, y: bubbleY))
        path.closeSubpath()

        return path
    }
}

// MARK: -
struct TailPopup: View {
    let text: String
    let color: Color
    let triangleOffset: CGFloat

    let popupHeight: CGFloat = 120
    let triangleSize = CGSize(width: 30, height: 15)
    let horizontalPadding: CGFloat = 16
    let cornerRadius: CGFloat = 16

    var body: some View {
        GeometryReader { geo in
            let fullWidth = geo.size.width - 2 * horizontalPadding
            let totalHeight = popupHeight + triangleSize.height

            ZStack {
                // Unified bubble shape
                TailBubble(
                    cornerRadius: cornerRadius,
                    triangleSize: triangleSize,
                    triangleOffset: triangleOffset
                )
                .fill(color)
                .frame(width: fullWidth, height: totalHeight)

                VStack {
                    Spacer().frame(height: triangleSize.height)
                        .padding(.bottom, 12)
                    Text(text)
                        .polyfont()
                        .foregroundStyle(Color(.white))
                        .padding(.horizontal, horizontalPadding)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    Button(action: {}, label: {
                        /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                            .foregroundStyle(Color("KiwiFill"))
                    })
                    .buttonStyle(MainButtonStyle(buttonColor: Color(.white), shadowColor: Color(.lightGray)))
                    .padding(.horizontal, horizontalPadding)
                    Spacer().frame(height:triangleSize.height)
                }
                .frame(width: fullWidth, height: totalHeight)
            }
            .padding(.horizontal, horizontalPadding)
        }
        .frame(height: popupHeight + triangleSize.height)
    }
}

#Preview {
    TailPopup(
        text: "popup",
        color: Color("KiwiFill"),
        triangleOffset: 0
    )
}
