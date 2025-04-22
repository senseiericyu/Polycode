import SwiftUI

// MARK: - Button Position PreferenceKey

struct ButtonFrameKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct ButtonPositionReader: ViewModifier {
    let index: Int
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: ButtonFrameKey.self,
                        value: [index: geo.frame(in: .global)]
                    )
                }
            )
    }
}

struct HomeView: View {
    let xOffsets: [CGFloat] = [0, -40, -60, -40, 0, 0]
    let icons: [String] = [
        "star.fill",
        "star.fill",
        "star.fill",
        "star.fill",
        "bubbles.and.sparkles.fill",
        "medal.star.fill"
    ]
    let colors: [String] = ["Kiwi"]
    var colorIndex: Int = 0

    @State private var selectedIndex: Int? = nil
    @State private var buttonFrames: [Int: CGRect] = [:]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color("Backdrop")
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    //top bar
                    TopHeader()
                        .padding(.horizontal, 18)
                        .padding(.bottom, 5)
                        .padding(.top, 15)

                    //header
                    SplitHeader(
                        leftAction: { },
                        rightAction: { },
                        leftLabel: "Sections",
                        rightLabel: "⚙️",
                        buttonColor: Color("\(colors[colorIndex])Fill"),
                        shadowColor: Color("\(colors[colorIndex])Shadow")
                    )
                    .padding(.bottom, 4) //padding for under header

                    HomepageStepView(
                        xOffsets: xOffsets,
                        icons: icons,
                        color: "\(colors[colorIndex])",
                        onSelect: { index in
                            withAnimation {
                                if selectedIndex == index {
                                    selectedIndex = nil
                                } else if selectedIndex != nil {
                                    withAnimation {
                                        selectedIndex = nil
                                    }
                                    selectedIndex = index
                                } else {
                                    selectedIndex = index
                                }
                            }
                        }
                    )
                }

                // tap-to-dismiss transparent overlay
                /* TODO: this portion makes popups work for now but there is no pop down animation. eventually we want to be able to have a popup and popdown animation
                 */
                if let index = selectedIndex, let frame = buttonFrames[index] {
                    // Smart tap-away catcher (under popup, only triggers if tap is outside popup)
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            selectedIndex = nil
                        }
                        .zIndex(0.5)

                    // Popup itself (fully interactive)
                    TailPopup(
                        text: "Popup for \(icons[index])",
                        color: Color("\(colors[colorIndex])Fill"),
                        triangleOffset: xOffsets[index]
                    )
                    .position(x: frame.midX, y: frame.maxY + 10)
                    .zIndex(1.0)
                }

            }
            .onPreferenceChange(ButtonFrameKey.self) { value in
                self.buttonFrames = value
            }
            
        }
    }
}

#Preview {
    HomeView()
}
