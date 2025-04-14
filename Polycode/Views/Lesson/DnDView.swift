//  Drag and Drop

import SwiftUI

struct DnDView: View {
    let originalTokens: [String]
    let correctOrder: [String]
    var onAnswered: ((Bool) -> Void)? = nil
    
    @State private var currentOrder: [String]
    @State private var isAnswered = false
    @State private var isCorrect = false
    
    var body: some View {
        Text("hello world")
    }
}

/*
 #Preview {
 DnDView()
 }
 */
