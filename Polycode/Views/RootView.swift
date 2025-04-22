import SwiftUI
import FirebaseFirestore
import FirebaseAuth

enum AppScreen {
    case initializing
    case auth
    case home
    case lesson(id: String)
    case sections
}

@Observable
class AppState {
    var screen: AppScreen = .initializing
    var showLoadingOverlay: Bool = false
    var session: SessionManager = SessionManager()

    func tryAutoSignIn() {
        if let user = Auth.auth().currentUser {
            session.fetchUserData(uid: user.uid) { [weak self] in
                self?.showLoadingThenHome(fromColdLaunch: true)
            }
        } else {
            screen = .auth
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

    func showHome() {
        screen = .home
    }
}

struct RootView: View {
    @State private var appState = AppState()
    @State private var model = LessonViewModel()

    var body: some View {
        ZStack {
            switch appState.screen {
            case .initializing:
                LoadingView()

            case .auth:
                SignInView(session: $appState.session) {
                    withAnimation {
                        appState.showLoadingThenHome(fromColdLaunch: false)
                    }
                }

            case .home:
                ZStack {
                    HomeView(model: model, onStartLesson: { id in
                        withAnimation { appState.screen = .lesson(id: id) }
                    }, appState: $appState)

                    if appState.showLoadingOverlay {
                        LoadingView()
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.3), value: appState.showLoadingOverlay)
                            .zIndex(1.0)
                    }
                }

            case .lesson(let id):
                if let lesson = model.lessons.first(where: { $0.id?.trimmingCharacters(in: .whitespacesAndNewlines) == id.trimmingCharacters(in: .whitespacesAndNewlines) }) {
                    LessonView(lesson: lesson, model: model) {
                        withAnimation {
                            appState.showHome()
                        }
                    }
                } else {
                    VStack {
                        Text("Loading lesson...")
                        Text("Looking for: \(id)")
                        Text("Available: \(model.lessons.compactMap(\.id).joined(separator: ", "))")
                    }
                }
            case .sections:
                SectionView(model: model) {
                    withAnimation {
                        appState.showHome()
                    }
                }
            }
        }
        .onAppear {
            appState.tryAutoSignIn()
        }
    }
}

#Preview {
    RootView()
}
