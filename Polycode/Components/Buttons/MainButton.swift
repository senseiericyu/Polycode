import SwiftUI

struct MainButtonStyle: ButtonStyle {
    let buttonColor: Color
    let shadowColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .polyfont()
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(buttonColor)
            .clipShape(.rect(cornerRadius: 12))
            .shadow(color: shadowColor, radius: 0, y: configuration.isPressed ? 0 : 4)
            .offset(y: configuration.isPressed ? 4 : 0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

//MARK: -View
struct MainButton: View {
    var body: some View {
        VStack {
            Button {} label: {
                Text("Check")
            }
            .buttonStyle(MainButtonStyle(
                buttonColor: Color("KiwiFill"),
                shadowColor: Color("KiwiShadow"
            )))
        }
        .padding()
    }
}

#Preview {
    MainButton()
}
