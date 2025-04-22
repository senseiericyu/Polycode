import SwiftUI

struct CorrectModal: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, Color("KiwiShadow"))
                        .font(.system(size: 36, weight: .bold))
                    
                    Text("Correct!")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("KiwiShadow"))
                }

                Button(action: {
                    onDismiss()
                }, label: {
                    Text("Next")
                        .foregroundColor(.white)
                })
                .buttonStyle(MainButtonStyle(
                    buttonColor: Color("KiwiFill"),
                    shadowColor: Color("KiwiShadow")
                ))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.25)
            .background(Color("KiwiHighlight").brightness(+0.15).saturation(0.65))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .transition(.move(edge: .bottom))
        }
        .ignoresSafeArea()
    }
}

#Preview {
    struct CorrectPreviewWrapper: View {
        @State private var show = true

        var body: some View {
            ZStack {
                Color.black.opacity(0.1).ignoresSafeArea()

                if show {
                    CorrectModal {
                        show = false
                    }
                }
            }
        }
    }

    return CorrectPreviewWrapper()
}
