//Multiple Choice
//encompasses True/False questions as well

import SwiftUI

struct MCView: View {
    let question: String
    let options: [String]
    let correctIndex: Int
    
    //MARK: onAnswered - a function that does something when question is answered; its action depends on whether question is answered correctly or not
    var onAnswered: ((Bool) -> Void)? = nil
    
    @State private var selectedIndex: Int? = nil
    @State private var isAnswered = false
    
    @State private var showIncorrectModal = false
    @State private var showCorrectModal = false

    
    @State private var progress = 1.0 / 8 //MARK: This may need to be a binding state in QuizView
    
    var body: some View {
       ZStack {
           VStack {
               HStack {
                   ProgressView(value: progress)
                       .tint(.green)
                       .scaleEffect(y: 3, anchor: .center)
                       .padding()
               }

               Text(question)
                   .font(.title3)
                   .bold()

               VStack(spacing: 16) {
                   ForEach(options.indices, id: \.self) { index in
                       Button {
                           selectedIndex = index
                       } label: {
                           Text(options[index])
                               .font(.body)
                       }
                       .buttonStyle(MCButtonStyle(isSelected: selectedIndex == index))
                   }
               }
               .padding()

               Spacer()

               Button("Check") {
                   guard let selected = selectedIndex else { return }
                   if selected == correctIndex {
                       isAnswered = true
                       showCorrectModal = true
                       progress += 1.0 / 8
                   } else {
                       showIncorrectModal = true
                   }
               }
               .buttonStyle(MainButtonStyle(
                   buttonColor: selectedIndex == nil ? Color("LockedGrayFill") : Color("KiwiFill"),
                   shadowColor: selectedIndex == nil ? Color("LockedGrayShadow") : Color("KiwiShadow")
               ))
               .disabled(selectedIndex == nil)
           }
           .padding()
           .blur(radius: (showIncorrectModal || showCorrectModal) ? 3 : 0)

           if showIncorrectModal {
               Color.black.opacity(0.4).ignoresSafeArea()
               IncorrectModal(correctAnswer: options[correctIndex]) {
                   showIncorrectModal = false
                   onAnswered?(false)
               }
           }

           if showCorrectModal {
               Color.black.opacity(0.4).ignoresSafeArea()
               CorrectModal {
                   showCorrectModal = false
                   onAnswered?(true)
               }
           }
       }
       .animation(.easeInOut, value: showIncorrectModal || showCorrectModal)
   }
}

// Preview contains sample question and answers
#Preview {
    MCView(question: "What case convention does Python use?", options: ["PascalCase", "camelCase", "snake_case", "kebab-case"], correctIndex: 2)
}

