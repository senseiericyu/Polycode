//
//  PolycodeApp.swift
//  Polycode
//
//  Created by Eric Yu on 4/10/25.
//

import SwiftUI
import SwiftData

@main
struct PolycodeApp: App {
    var sharedModelContainer: ModelContainer = {
        try! ModelContainer(for: User.self)
    }()

    var body: some Scene {
        WindowGroup {
            LoadingView()
                .modelContainer(sharedModelContainer)
        }
    }
}
