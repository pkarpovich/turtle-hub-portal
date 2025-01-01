//
//  ChatViewModel.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 01/01/2025.
//

import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentText: String = ""
    
    private let chatService = ChatService()
    
    init() {
        chatService.fetchMessages { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedMessages):
                    self?.messages = fetchedMessages
                case .failure(let error):
                    print("Message load error: \(error)")
                }
            }
        }
    }
    
    func sendMessage() {
        let userMessage = Message(id: UUID().uuidString, text: currentText, isUserMessage: true)
        messages.append(userMessage)
        
        chatService.sendMessage(content: currentText) { [weak self] resp in
            switch resp {
            case .success(let msg):
                DispatchQueue.main.async {
                    self?.messages.append(msg)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        currentText = ""
    }
}
