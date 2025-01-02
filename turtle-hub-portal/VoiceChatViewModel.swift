//
//  VoiceChatViewModel.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 01/01/2025.
//

import SwiftUI

class VoiceChatViewModel: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var isLoading: Bool = false
    @Published var responseText: String = ""
    
    private let audioRecorder = AudioRecorder()
    private let endpoint = "http://localhost:8080/api/message/voice"
    
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
            print("Ошибка при старте записи: \(error)")
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
            print("Ошибка при остановке записи: \(error)")
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
                print("Ошибка при отправке: \(error)")
                return
            }
            guard let responseData = responseData else {
                print("Нет данных в ответе")
                return
            }
            let decodedTranscript = String(data: responseData, encoding: .utf8) ?? "Неизвестный ответ"
            
            DispatchQueue.main.async {
                self?.responseText = decodedTranscript
            }
        }.resume()
    }
}
