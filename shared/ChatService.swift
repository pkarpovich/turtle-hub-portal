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

struct SendMessageRequestBody: Codable {
    struct InnerMessage: Codable {
        let content: String
    }
    let message: InnerMessage
}

struct SendMessageResponseBody: Codable {
    let success: Bool
    let response: String
}

class ChatService {
    private let endpoint = (ProcessInfo.processInfo.environment["SERVER_URL"] ?? "http://192.168.198.3/gateway") + "/api/messages"
    
    func fetchMessages(isLoading: @escaping (Bool) -> Void, completion: @escaping (Result<[Message], Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }
        
        isLoading(true)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
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
                    Message(
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
}
