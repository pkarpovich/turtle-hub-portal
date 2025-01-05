//
//  StartListeningIntent.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 05/01/2025.
//
import AppIntents

struct StartListeningIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Listening"
    static var openAppWhenRun: Bool = true
    static var isDiscoverable: Bool = true
    
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(name: NSNotification.Name("StartListening"), object: nil)
        return .result()
    }
}
