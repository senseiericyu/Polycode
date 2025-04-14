import Foundation
import SwiftData

@MainActor
@Observable
class UserData {
    var user: User

    init(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<User>()

        if let existing = try? modelContext.fetch(descriptor).first {
            self.user = existing
        } else {
            let newUser = User(name: "Player 1")
            modelContext.insert(newUser)
            self.user = newUser
        }
    }
}
