//Multiple Choice
//encompasses True/False questions

import SwiftUI

struct MCView: View {
    let options: [String]
    let correctIndex: Int
    var onAnswered: ((Bool) -> Void)? = nil
    
    
    @State private var selectedIndex: Int? = nil
    @State private var isAnswered = false
    
    var body: some View {
        Text("hello world")
    }
}

/*
#Preview {
    MCView()
}
*/
