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
    @Published var errorMessage: String? = nil
    
    private let audioRecorder = AudioRecorder()
    private let endpoint = (ProcessInfo.processInfo.environment["SERVER_URL"] ?? "http://192.168.198.3/gateway") + "/api/message/voice"
    
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
            errorMessage = nil
        } catch {
            errorMessage = "Failed to start recording: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }
    
    func stopRecording() {
        do {
            guard let data = try audioRecorder.stopRecording() else {
                isRecording = false
                return
            }
            isRecording = false
        } catch {
            errorMessage = "Failed to stop recording: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
            isRecording = false
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
            errorMessage = "Failed to stop recording: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
            isRecording = false
        }
    }
    
    private func sendAudioData(_ data: Data) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: endpoint) else {
            errorMessage = "Invalid URL"
            print(errorMessage ?? "Unknown error")
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
                if let urlError = error as? URLError {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Network error: \(urlError.localizedDescription). Code: \(urlError.errorCode). URL: \(url)"
                    }
                    print("Network error: \(urlError.localizedDescription). Code: \(urlError.errorCode)")
                } else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Unknown error: \(error.localizedDescription)"
                    }
                    print("Unknown error: \(error.localizedDescription)")
                }
                return
            }
            guard let responseData = responseData else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received from server"
                }
                print("No data in response")
                return
            }
            do {
                let serverResponse = try JSONDecoder().decode(SendMessageResponseBody.self, from: responseData)
                
                DispatchQueue.main.async {
                    self?.responseText = serverResponse.response
                    self?.playDefaultBeepSound()
                }
            } catch {
                let decodedJSON = String(data: responseData, encoding: .utf8) ?? "Unknown response"
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to decode response: \(error.localizedDescription). Server response: \(decodedJSON)"
                }
                print("Error decoding JSON: \(error.localizedDescription)")
                print("Server response: \(decodedJSON)")
            }
        }.resume()
    }
    
    private func playDefaultBeepSound() {
        WKInterfaceDevice.current().play(.success)
    }
}
