//
//  RootView.swift
//  Polycode
//
//  Created by Eric Yu on 4/16/25.
//


/*
import SwiftUI

enum AppScreen {
    case home
    case lesson(id: String)
}

struct RootView: View {
    @State private var screen: AppScreen = .home

    var body: some View {
        ZStack {
            switch screen {
            case .home:
                HomeView(onStartLesson: { lessonID in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        screen = .lesson(id: lessonID)
                    }
                })

            case .lesson(let id):
                LessonView(lessonID: id, onExit: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        screen = .home
                    }
                })
                .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    RootView(screen: <#T##AppScreen#>)
}
*/
