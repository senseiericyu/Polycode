//Writing Code

import SwiftUI

struct CodeWriteView: View {
    let prompt: String
    let expectedCode: String
    var onAnswered: ((Bool) -> Void)? = nil

    @State private var userCode: String = ""
    @State private var isAnswered = false
    @State private var isCorrect = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

/*
 #Preview {
 CodeWriteView()
 }
 */
