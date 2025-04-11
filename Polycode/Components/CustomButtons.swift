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
    }
}

struct PathButtonStyle: ButtonStyle {
    let buttonColor: Color
    let shadowColor: Color
    let highlightColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: 30, maxHeight: 20)
            .padding()
            .background(
                ZStack {
                    buttonColor
                    Ellipse()
                        .fill(.clear)
                        .overlay(
                            ZStack {
                                HStack(spacing: 8) {
                                    Rectangle()
                                        .fill(highlightColor)
                                        .frame(width: 10, height: .infinity)
                                    
                                    Rectangle()
                                        .fill(highlightColor)
                                        .frame(width: 20, height: .infinity)
                                }
                                .frame(height: 50)
                                .offset(x: -5)
                                .rotationEffect(.degrees(40))
                            }
                        )
                    Ellipse()
                        .strokeBorder(buttonColor, lineWidth: 5)
                    
                }
            )
            .clipShape(.ellipse)
            .foregroundStyle(.white)
            .shadow(color: shadowColor, radius: 0, y: configuration.isPressed ? 0 : 5.5)
            .offset(y: configuration.isPressed ? 4 : 0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}


struct CustomButtons: View {
    var body: some View {
        VStack {
            //CheckButton
            /*
            Button {} label: {
                Text("Check")
            }
            .buttonStyle(CheckButtonStyle(buttonColor: Color("KiwiFill"), shadowColor: Color("KiwiShadow")))
             */
            
            //PathButton
            /*
            Button {} label: {
                Image(systemName: "star.fill")
            }
            .buttonStyle(PathButtonStyle(
                buttonColor: Color("VictoryGoldFill"),
                shadowColor: Color("VictoryGoldShadow"),
                highlightColor: Color("VictoryGoldHighlight")
            ))
             */
            
            //Greyed out
            Button {} label: {
                Image(systemName: "star.fill")
                    .foregroundStyle(Color(.gray))
            }
            .buttonStyle(PathButtonStyle(
                buttonColor: Color("LockedGrayFill"),
                shadowColor: Color("LockedGrayShadow"),
                highlightColor: Color(.clear)
            ))
            
        }
        .padding()
    }
}

#Preview {
    CustomButtons()
}
