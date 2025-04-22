import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            Text("loading")
                .font(.title.bold())
                .foregroundColor(.black)
        }
    }
}
