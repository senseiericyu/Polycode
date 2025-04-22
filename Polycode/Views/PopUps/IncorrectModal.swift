//
//  IncorrectModal.swift
//  Polycode
//
//  Created by Mia Yang on 4/22/25.
//

import SwiftUI

struct IncorrectModal: View {
    let correctAnswer: String
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 28, weight: .bold))
                Text("Incorrect")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.red)
            }
            
            VStack(spacing: 4) {
                Text("Correct Answer:")
                    .font(.body)
                    .bold()
                    .foregroundColor(.red)
                
                Text(correctAnswer)
                    .font(.title3)
                    .foregroundColor(.red)
            }
            
            Button("GOT IT") {
                onDismiss()
            }
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .cornerRadius(20)
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 18/255, green: 28/255, blue: 36/255))
        .cornerRadius(16)
        .padding()
    }
}
