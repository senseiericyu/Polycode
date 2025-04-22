//
//  SettingsView.swift
//  Polycode
//
//  Created by Eric Yu on 4/22/25.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var appState: AppState

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Button("Sign Out") {
                    do {
                        try Auth.auth().signOut()
                        print("✅ Sign out successful")
                        appState.screen = .auth
                        appState.showLoadingOverlay = false
                        dismiss()
                    } catch {
                        print("❌ Sign out failed: \(error.localizedDescription)")
                    }
                }
                .polyfont()
                .foregroundColor(.red)
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

