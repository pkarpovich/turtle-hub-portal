//
//  turtle_hub_portalApp.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 05/01/2025.
//

import SwiftUI

@main
struct turtle_hub_portalApp: App {
    @StateObject private var chatViewModel = ChatViewModel()
    
    var body: some Scene {
        WindowGroup {
            ChatView(viewModel: chatViewModel)
        }
    }
}
