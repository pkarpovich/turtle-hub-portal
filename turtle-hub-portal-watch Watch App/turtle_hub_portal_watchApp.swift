//
//  turtle_hub_portal_watchApp.swift
//  turtle-hub-portal-watch Watch App
//
//  Created by Pavel Karpovich on 01/01/2025.
//

import SwiftUI

@main
struct turtle_hub_portal_watch_Watch_AppApp: App {
    @StateObject private var viewModel = WatchVoiceViewModel()
    @State private var navigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                WatchVoiceView()
                    .environmentObject(viewModel)
                    .navigationDestination(for: String.self) { route in
                        if route == "WatchVoiceView" {
                            WatchVoiceView()
                                .environmentObject(viewModel)
                                .navigationBarBackButtonHidden(true)
                        }
                    }
            }
            .onAppear {
                setupNotifications()
            }
            .onDisappear {
                removeNotifications()
            }
        }
        
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("StartListening"), object: nil, queue: .main) { _ in
            navigationPath.append("WatchVoiceView")
            viewModel.toggleRecording()
        }
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("StartListening"), object: nil)
    }
}
