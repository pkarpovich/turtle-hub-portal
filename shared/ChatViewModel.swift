//
//  ChatViewModel.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 01/01/2025.
//

import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var messages: [ChatMessage] = []
    @Published var errorMessage: String? = nil
    
    private let chatService = ChatService()
    
    init() {
        chatService.fetchMessages(isLoading: { [weak self] loading in
            DispatchQueue.main.async {
                self?.isLoading = loading
            }
        }) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedMessages):
                    self?.messages = fetchedMessages
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
