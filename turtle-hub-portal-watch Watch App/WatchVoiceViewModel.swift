//
//  WatchVoiceViewModel.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 02/01/2025.
//

import SwiftUI
import AVFoundation

class WatchVoiceViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var isLoading = false
    @Published var responseText = ""
    @Published var errorMessage: String?
    @Published var messages: [ChatMessage] = []
    
    private let audioRecorder = AudioRecorder()
    private let chatService = ChatService()
    
    func toggleRecording() {
        isRecording ? stopRecordingAndSend() : startRecording()
    }
    
    func fetchMessages() {
        messages = []
        isLoading = true
        errorMessage = nil
        
        chatService.fetchMessages(isLoading: { [weak self] loading in
            DispatchQueue.main.async {
                self?.isLoading = loading
            }
        }, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.messages = messages
                case .failure(let error):
                    self?.handleError("Failed to fetch messages", error)
                }
            }
        })
    }
    
    private func startRecording() {
        do {
            resetStateForNewRecording()
            try audioRecorder.startRecording()
        } catch {
            isRecording = false
            handleError("Failed to start recording", error)
        }
    }
    
    func stopRecording() {
        do {
            guard let _ = try audioRecorder.stopRecording() else {
                isRecording = false
                return
            }
            isRecording = false
        } catch {
            handleError("Failed to stop recording", error)
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
            handleError("Failed to stop recording", error)
        }
    }
    
    private func resetStateForNewRecording() {
        isRecording = true
        responseText = ""
        errorMessage = nil
    }
    
    private func sendAudioData(_ data: Data) {
        isLoading = true
        errorMessage = nil
        
        chatService.sendVoiceData(data, isLoading: { [weak self] loading in
            DispatchQueue.main.async {
                self?.isLoading = loading
            }
        }, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.responseText = response.response
                    self?.playDefaultBeepSound()
                case .failure(let error):
                    self?.handleError("Failed to send voice data", error)
                }
            }
        })
    }
    
    private func handleError(_ message: String, _ error: Error? = nil, additionalInfo: String? = nil) {
        let fullMessage = error.map { "\(message): \($0.localizedDescription)" } ?? message
        let additionalDetails = additionalInfo.map { "\nServer response: \($0)" } ?? ""
        
        DispatchQueue.main.async {
            self.errorMessage = fullMessage + additionalDetails
        }
        print(fullMessage + additionalDetails)
    }
    
    private func playDefaultBeepSound() {
        WKInterfaceDevice.current().play(.success)
    }
}
