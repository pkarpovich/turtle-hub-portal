//
//  WatchVoiceViewModel.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 02/01/2025.
//

import SwiftUI
import AVFoundation

class WatchVoiceViewModel: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var isLoading: Bool = false
    @Published var responseText: String = ""
    
    private let audioRecorder = AudioRecorder()
    private let endpoint = (ProcessInfo.processInfo.environment["SERVER_URL"] ?? "http://localhost:8080") + "/api/message/voice"
    
    func toggleRecording() {
        if isRecording {
            stopRecordingAndSend()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        do {
            try audioRecorder.startRecording()
            isRecording = true
            responseText = ""
        } catch {
            print("Error starting recording: \(error)")
        }
    }
    
    private func stopRecordingAndSend() {
        do {
            guard let data = try audioRecorder.stopRecording() else {
                isRecording = false
                return
            }
            isRecording = false
            sendAudioData(data)
        } catch {
            print("Error stopping recording: \(error)")
            isRecording = false
        }
    }
    
    private func sendAudioData(_ data: Data) {
        isLoading = true
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            self.isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { [weak self] responseData, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
            if let error = error {
                print("Error sending data: \(error)")
                return
            }
            guard let responseData = responseData else {
                print("No data in response")
                return
            }
            do {
                let serverResponse = try JSONDecoder().decode(SendMessageResponseBody.self, from: responseData)
                
                DispatchQueue.main.async {
                    self?.responseText = serverResponse.response
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                let decodedJSON = String(data: responseData, encoding: .utf8) ?? "Unknown response"
                print("Server response: \(decodedJSON)")
            }
        }.resume()
    }
}
