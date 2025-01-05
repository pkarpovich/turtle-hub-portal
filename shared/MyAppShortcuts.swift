//
//  MyAppShortcuts.swift
//  turtle-hub-portal-watch Watch App
//
//  Created by Pavel Karpovich on 05/01/2025.
//

import AppIntents

struct MyAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartListeningIntent(),
            phrases: ["Start listening in \(.applicationName)"],
            shortTitle: "Start listening",
            systemImageName: "mic.fill"
        )
    }
}
