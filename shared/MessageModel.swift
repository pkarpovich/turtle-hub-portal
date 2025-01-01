//
//  MessageModel.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 01/01/2025.
//
import Foundation

struct Message: Identifiable, Equatable {
    let id: String
    let text: String
    let isUserMessage: Bool
    
    init(id: String, text: String, isUserMessage: Bool) {
        self.id = id
        self.text = text
        self.isUserMessage = isUserMessage
    }
}
