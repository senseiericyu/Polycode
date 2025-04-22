//
//  CorrectModal.swift
//  Polycode
//
//  Created by Eric Yu on 4/22/25.
//


//
//  CorrectModal.swift
//  Polycode
//
//  Created by Mia Yang on 4/22/25.
//

import SwiftUI

struct CorrectModal: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 28, weight: .bold))
                Text("Correct!")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.green)
            }
            
            Text("Great job! 🎉")
                .foregroundColor(.green)
                .font(.body)
            
            Button("Continue") {
                onDismiss()
            }
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
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