import SwiftUI
import SwiftData

struct LoadingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var userData: UserData?
    @State private var isLoaded = false

    var body: some View {
        Group {
            if let userData, isLoaded {
                HomeView()
                    .environment(userData)
            } else {
                VStack {
                    Spacer()
                    ProgressView("Loading your progress…")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                    Spacer()
                }
                .task {
                    await loadUserData()
                }
            }
        }
    }

    @MainActor
    func loadUserData() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let data = UserData(modelContext: modelContext)
        userData = data
        isLoaded = true
    }
}
