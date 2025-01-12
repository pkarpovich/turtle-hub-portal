//
//  ChatService.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 01/01/2025.
//

import Foundation

struct MessagesResponse: Codable {
    let messages: [FetchedMessage]
}

struct FetchedMessage: Codable {
    let id: String
    let role: String
    let content: String
}

struct ChatMessage: Identifiable, Codable {
    let id: String
    let text: String
    let isUserMessage: Bool
}

struct SendMessageResponseBody: Codable {
    let success: Bool
    let response: String
}

class ChatService {
    private let messangesEndpoint = (ProcessInfo.processInfo.environment["SERVER_URL"] ?? "http://192.168.198.3/gateway") + "/api/messages"
    private let voiceEndpoint = (ProcessInfo.processInfo.environment["SERVER_URL"] ?? "http://192.168.198.3/gateway") + "/api/message/voice"
    
    func fetchMessages(isLoading: @escaping (Bool) -> Void, completion: @escaping (Result<[ChatMessage], Error>) -> Void) {
        guard let url = URL(string: messangesEndpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        isLoading(true)
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading(false)
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(MessagesResponse.self, from: data)
                let messages = responseObject.messages.map { singleMsg in
                    ChatMessage(
                        id: singleMsg.id,
                        text: singleMsg.content,
                        isUserMessage: singleMsg.role == "user"
                    )
                }
                
                completion(.success(messages))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func sendVoiceData(_ data: Data, isLoading: @escaping (Bool) -> Void, completion: @escaping (Result<SendMessageResponseBody, Error>) -> Void) {
        guard let url = URL(string: voiceEndpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        isLoading(true)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                isLoading(false)
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(SendMessageResponseBody.self, from: data)
                completion(.success(responseObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
