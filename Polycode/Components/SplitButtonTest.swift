import SwiftUI

enum PressedSide {
    case left, right, none
}

struct TestSplitHeader: View {
    let leftAction: () -> Void
    let rightAction: () -> Void
    let leftLabel: String
    let rightLabel: String
    let buttonColor: Color
    let shadowColor: Color

    @GestureState private var isLeftPressed: Bool = false
    @GestureState private var isRightPressed: Bool = false

    @State private var animatedSlant: CGFloat = 0
    @State private var activeSide: PressedSide = .none

    private let buttonHeight: CGFloat = 80
    private let dividerWidth: CGFloat = 2
    private let dividerOffset: CGFloat = 4 // matches shadow/slant padding

    var pressedSide: PressedSide {
        if isLeftPressed { return .left }
        else if isRightPressed { return .right }
        else { return .none }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            SplitHeaderLayout(dividerWidth: dividerWidth) {
                Button(action: leftAction) {
                    Text(leftLabel)
                        .frame(maxHeight: .infinity)
                }
                .buttonStyle(SplitButtonStyle(
                    buttonColor: buttonColor,
                    shadowColor: shadowColor,
                    corners: [.topLeft, .bottomLeft]
                ))
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .updating($isLeftPressed) { _, state, _ in
                            state = true
                        }
                )

                Button(action: rightAction) {
                    Text(rightLabel)
                        .frame(maxHeight: .infinity)
                }
                .buttonStyle(SplitButtonStyle(
                    buttonColor: buttonColor,
                    shadowColor: shadowColor,
                    corners: [.topRight, .bottomRight]
                ))
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .updating($isRightPressed) { _, state, _ in
                            state = true
                        }
                )
            }
            .frame(height: buttonHeight)

            GeometryReader { geo in
                MorphingDividerShape(morphValue: animatedSlant)
                    .fill(shadowColor)
                    .frame(width: dividerWidth, height: buttonHeight + dividerOffset)
                    .offset(x: geo.size.width * 0.8)
            }
        }
        .frame(height: buttonHeight)
        .onChange(of: pressedSide) {
            let isPressing = pressedSide != .none
            let animation: Animation = isPressing
                ? .easeIn(duration: 0.342)
                : .interpolatingSpring(stiffness: 350, damping: 30)

            withAnimation(animation) {
                switch pressedSide {
                case .left:  animatedSlant = -1
                case .right: animatedSlant = 1
                case .none:  animatedSlant = 0
                }
            }
        }
    }
}

struct SplitHeaderLayout: Layout {
    var dividerWidth: CGFloat = 2
    var leftRatio: CGFloat = 0.8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        let height = proposal.height ?? subviews.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard subviews.count == 2 else { return }

        let totalWidth = bounds.width
        let leftWidth = totalWidth * leftRatio
        let rightWidth = totalWidth * (1 - leftRatio) - dividerWidth

        let leftFrame = CGRect(x: bounds.minX, y: bounds.minY, width: leftWidth, height: bounds.height)
        let rightFrame = CGRect(x: bounds.minX + leftWidth + dividerWidth, y: bounds.minY, width: rightWidth, height: bounds.height)

        subviews[0].place(at: leftFrame.origin, proposal: ProposedViewSize(leftFrame.size))
        subviews[1].place(at: rightFrame.origin, proposal: ProposedViewSize(rightFrame.size))
    }
}



#Preview {
    TestSplitHeader(
        leftAction: { print("Left tapped") },
        rightAction: { print("Right tapped") },
        leftLabel: "Profile",
        rightLabel: "⚙️",
        buttonColor: Color("KiwiFill"),
        shadowColor: Color("KiwiShadow")
    )
}
