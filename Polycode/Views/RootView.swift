import SwiftUI
import FirebaseFirestore
import FirebaseAuth

enum AppScreen {
    case initializing
    case auth
    case home
    case lesson(id: String)
}

@Observable
class AppState {
    var screen: AppScreen = .initializing
    var showLoadingOverlay: Bool = false
    var session: SessionManager = SessionManager()
    var isColdLaunch: Bool = true
    
    init() {
        tryAutoSignIn()
    }
    
    func tryAutoSignIn() {
        if let user = Auth.auth().currentUser {
            session.fetchUserData(uid: user.uid) { [weak self] in
                self?.showLoadingThenHome(fromColdLaunch: true)
            }
        } else {
            self.screen = .auth
        }
    }
    
    func showLoadingThenHome(fromColdLaunch: Bool) {
        screen = .home

        if fromColdLaunch {
            showLoadingOverlay = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showLoadingOverlay = false
            }
        } else {
            showLoadingOverlay = false
        }
    }

}

struct RootView: View {
    @State private var appState = AppState()
    
    var body: some View {
        ZStack {
            switch appState.screen {
            case .initializing:
                LoadingView()
            case .auth:
                SignInView(session: $appState.session) {
                    withAnimation {
                        appState.showLoadingThenHome(fromColdLaunch: true)
                    }
                }
                
            case .home:
                ZStack {
                    HomeView(onStartLesson: { id in
                        withAnimation { appState.screen = .lesson(id: id) }
                    })

                    
                    if appState.showLoadingOverlay {
                        LoadingView()
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.3), value: appState.showLoadingOverlay)
                            .zIndex(1.0)
                    }
                }
                
            case .lesson(let id):
                VStack(spacing: 20) {
                    Text("Lesson: \(id)")
                        .font(.title)
                    
                    Button("✅ Mark as Solved") {
                        if let user = Auth.auth().currentUser {
                            let userRef = Firestore.firestore().collection("users").document(user.uid)
                            userRef.updateData([
                                "solvedLessonIDs": FieldValue.arrayUnion([id])
                            ]) { error in
                                if let error = error {
                                    print("❌ Failed to mark lesson as solved: \(error)")
                                } else {
                                    print("✅ Lesson marked as solved: \(id)")
                                    withAnimation {
                                        appState.showLoadingThenHome(fromColdLaunch: false)
                                    }
                                }
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
    }
}


#Preview {
    RootView()
}
