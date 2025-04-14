import SwiftUI

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

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
                VStack {
                    HStack {
                        Image(systemName: "flag") //language emoji
                        Spacer()
                        Image(systemName: "flame") //streak
                        Spacer()
                        Image(systemName: "diamond.fill") //points/xp or something
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 5)
                    .padding(.top, 15)
                    
                    SplitHeader(
                        leftAction: {  },
                        rightAction: {  },
                        leftLabel: "Profile",
                        rightLabel: "⚙️",
                        buttonColor: Color("\(colors[colorIndex])Fill"),
                        shadowColor: Color("\(colors[colorIndex])Shadow")
                    )
                    .padding(.bottom, -5)

                    HomepageStepView(xOffsets: xOffsets, icons: icons, color: "\(colors[colorIndex])")
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}


#Preview {
    HomeView()
}
