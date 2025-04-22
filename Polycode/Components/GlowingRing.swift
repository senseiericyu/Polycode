import SwiftUI

struct GlowingRing: View {
    @State private var pulse = false
    let color = Color(.red)

    var body: some View {
        Ellipse()
            .stroke(color, lineWidth: 7)
            .scaleEffect(x: pulse ? 1.1 : 0.9, y: pulse ? 1 : 0.85)
            .offset(y: 3.3)
            .animation(
                Animation.easeOut(duration: 0.75)
                    .repeatForever(autoreverses: true)
                    .delay(pulse ? 1 : 0.0),
                value: pulse
            )
            .onAppear {
                withAnimation {
                    pulse = true
                }
            }
    }
}

