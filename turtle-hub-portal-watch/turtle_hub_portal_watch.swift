//
//  turtle_hub_portal_watch.swift
//  turtle-hub-portal-watch
//
//  Created by Pavel Karpovich on 05/01/2025.
//

import AppIntents

struct turtle_hub_portal_watch: AppIntent {
    static var title: LocalizedStringResource { "turtle-hub-portal-watch" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
