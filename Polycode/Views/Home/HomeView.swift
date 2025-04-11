import SwiftUI

struct HomeView: View {
    @Environment(UserData.self) var userData

    var body: some View {
        Text("Welcome, \(userData.user.name)!")
            .padding()
    }
}
