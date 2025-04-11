import SwiftUI

struct CheckButtonStyle: ButtonStyle {
    let buttonColor: Color
    let shadowColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textCase(.uppercase)
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .frame(maxWidth: .infinity)
            .padding()
            .background(buttonColor)
            .clipShape(.rect(cornerRadius: 12))
            .foregroundStyle(.white)
            .shadow(color: shadowColor, radius: 0, y: configuration.isPressed ? 0 : 4)
            .offset(y: configuration.isPressed ? 4 : 0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .sensoryFeedback(
                configuration.isPressed
                ? .impact(flexibility: .soft, intensity: 0.75)
                : .impact(flexibility: .solid),
                trigger: configuration.isPressed
            )
    }
}

struct PathButtonStyle: ButtonStyle {
    let buttonColor: Color
    let shadowColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: 30, maxHeight: 20)
            .padding()
            .background(buttonColor)
            .clipShape(.ellipse)
            .foregroundStyle(.white)
            .shadow(color: shadowColor, radius: 0, y: configuration.isPressed ? 0 : 5.5)
            .offset(y: configuration.isPressed ? 4 : 0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .sensoryFeedback(
                configuration.isPressed
                ? .impact(flexibility: .soft, intensity: 0.75)
                : .impact(flexibility: .solid),
                trigger: configuration.isPressed
            )
    }
}


struct CustomButtons: View {
    var body: some View {
        VStack {
            //Check button testing
            Button {} label: {
                Text("Check")
            }
            .buttonStyle(CheckButtonStyle(buttonColor: Color("KiwiFill"), shadowColor: Color("KiwiShadow")))
            
            //PathButton Testing
            Button {} label: {
                Image(systemName: "star.fill")
            }
            .buttonStyle(PathButtonStyle(
                buttonColor: Color("KiwiFill"),
                shadowColor: Color("KiwiShadow")
                ))
            
        }
        .padding()
    }
}

#Preview {
    CustomButtons()
}
