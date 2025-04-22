import SwiftUI

struct TopHeader: View {
    @State private var showStreakSheet = false
    @State private var showGemSheet = false
    @State private var showSettingsSheet = false
    
    let loggedDates: [Date]
    
    @Binding var appState: AppState

    var body: some View {
        HStack {
            // Language Button
            Button(action: {}, label: {
                Image("Python-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .background(Color("Backdrop"))
            })

            Spacer()

            // Streak Button
            Button(action: {
                showStreakSheet = true
            }, label: {
                Image("Fire")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .background(Color("Backdrop"))
            })

            Spacer()

            // Currency Button
            Button(action: {}, label: {
                Image(systemName: "diamond.fill")
            })

            Spacer()

            // Hearts Button
            Button(action: {
                showSettingsSheet = true
            }, label: {
                Image(systemName: "gear")
                    .foregroundStyle(.gray)
            })
        }
        .sheet(isPresented: $showStreakSheet) {
            ZStack {
                Color.white.ignoresSafeArea()
                StreakView(loggedDates: loggedDates)
            }
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsView(appState: $appState)
                .ignoresSafeArea()
        }

        .padding(.horizontal, 4)
    }
}
