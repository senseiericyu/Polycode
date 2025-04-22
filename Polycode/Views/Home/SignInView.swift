import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@Observable
class SessionManager {
    var currentUser: UserData?
    var isAuthenticated: Bool = false

    private let db = Firestore.firestore()

    func signIn(email: String, password: String, onSuccess: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let user = result?.user {
                self?.fetchUserData(uid: user.uid, onSuccess: onSuccess)
            } else {
                print("Sign-in failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func signUp(email: String, password: String, name: String, onSuccess: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let user = result?.user {
                let newUser = UserData(
                    id: user.uid,
                    name: name,
                    email: email,
                    streak: 0,
                    lastLogged: [Date()],
                    createdAt: Date(),
                    solvedLessonIDs: []
                )
                do {
                    try self?.db.collection("users").document(user.uid).setData(from: newUser)
                    self?.currentUser = newUser
                    self?.isAuthenticated = true
                    onSuccess()
                } catch {
                    print("Failed to save new user: \(error)")
                }
            } else {
                print("Sign-up failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func fetchUserData(uid: String, onSuccess: @escaping () -> Void) {
        let ref = db.collection("users").document(uid)
        ref.getDocument { [weak self] snapshot, error in
            if let document = snapshot, document.exists {
                do {
                    self?.currentUser = try document.data(as: UserData.self)
                    self?.isAuthenticated = true
                    onSuccess()
                } catch {
                    print("Decoding error: \(error)")
                }
            } else {
                print("User not found")
            }
        }
    }

}

struct SignInView: View {
    @Binding var session: SessionManager
    var onSignedIn: () -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isNewUser = false

    var body: some View {
        VStack(spacing: 20) {
            Image("Paulie-noback")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 200)
                .padding(.top, -150)
            Text("Welcome to Polycode")
                .font(.title.bold())
                .polyfont()

            TextField("Email", text: $email)
                .polyfont()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .polyfont()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)

            if isNewUser {
                TextField("Your Name", text: $name)
                    .polyfont()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
            }

            Button(isNewUser ? "Create Account" : "Sign In") {
                if isNewUser {
                    session.signUp(email: email, password: password, name: name, onSuccess: onSignedIn)
                } else {
                    session.signIn(email: email, password: password, onSuccess: onSignedIn)
                }
            }
            .polyfont()
            .buttonStyle(.borderedProminent)

            Button(isNewUser ? "Already have an account? Sign In" : "New here? Create Account") {
                isNewUser.toggle()
            }
            .font(.footnote)
            .polyfont()
        }
        .padding()
    }
}

#Preview {
    struct SignInPreviewWrapper: View {
        @State private var session = SessionManager()

        var body: some View {
            SignInView(session: $session) {
                print("✅ Signed in successfully!")
            }
        }
    }

    return SignInPreviewWrapper()
}
