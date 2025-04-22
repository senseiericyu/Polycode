import SwiftUI

struct IncorrectModal: View {
    let correctAnswer: String
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Spacer() // Push to bottom

            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, Color("WrongRedShadow"))
                        .font(.system(size: 36, weight: .bold))
                    Text("Incorrect")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("WrongRedShadow"))

                    VStack(spacing: 4) {
                        Text("Correct Answer:")
                            .font(.body)
                            .foregroundStyle(Color("WrongRedShadow"))

                        Text(correctAnswer)
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color("WrongRedShadow"))
                    }
                }

                Button(action: {
                    onDismiss()
                }, label: {
                    Text("Got It")
                        .foregroundColor(.white)
                })
                .buttonStyle(MainButtonStyle(
                    buttonColor: Color("WrongRedFill"),
                    shadowColor: Color("WrongRedShadow")
                ))
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.28)
            .background(Color("WrongRedHighlight"))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .transition(.move(edge: .bottom))
        }
        .ignoresSafeArea()
    }
}

#Preview {
    struct IncorrectPreviewWrapper: View {
        @State private var show = true

        var body: some View {
            ZStack {
                Color.black.opacity(0.1).ignoresSafeArea()
                
                if show {
                    IncorrectModal(correctAnswer: "snake_case") {
                        show = false
                    }
                }
            }
        }
    }

    return IncorrectPreviewWrapper()
}
