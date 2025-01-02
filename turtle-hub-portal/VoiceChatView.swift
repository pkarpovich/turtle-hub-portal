//
//  VoiceChatView.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 01/01/2025.
//

import SwiftUI

struct VoiceChatView: View {
    @StateObject private var viewModel = VoiceChatViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            // Кнопка микрофона
            ZStack {
                Circle()
                    .fill(viewModel.isRecording ? Color.red : Color.blue)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "mic.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .onTapGesture {
                viewModel.toggleRecording()
            }
            
            Spacer()
            
            if viewModel.isLoading {
                ProgressView("Отправляем аудио...")
                    .padding()
            }
            
            if !viewModel.responseText.isEmpty {
                Text("Ответ: \(viewModel.responseText)")
                    .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Голосовой чат")
    }
}

#Preview {
    VoiceChatView()
}
