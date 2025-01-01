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
    func fetchMessages(completion: @escaping (Result<[Message], Error>) -> Void) {
            guard let url = URL(string: "http://localhost:8080/api/messages") else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
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
    
    func sendMessage(content: String, completion: @escaping (Result<Message, Error>) -> Void) {
            guard let url = URL(string: "http://localhost:8080/api/message") else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = SendMessageRequestBody(message: .init(content: content))
            do {
                let bodyData = try JSONEncoder().encode(body)
                request.httpBody = bodyData
            } catch {
                completion(.failure(error))
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let serverResponse = try JSONDecoder().decode(SendMessageResponseBody.self, from: data)
                    let replyMessage = Message(
                        id: UUID().uuidString,
                        text: serverResponse.response,
                        isUserMessage: false
                    )
                    completion(.success(replyMessage))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
}
