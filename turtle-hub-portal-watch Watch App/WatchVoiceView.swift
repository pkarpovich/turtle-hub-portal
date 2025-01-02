//
//  Untitled.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 02/01/2025.
//

import SwiftUI

struct WatchVoiceView: View {
    @StateObject var viewModel = WatchVoiceViewModel()
    @State private var animateCircle = false
    
    var body: some View {
        VStack {
            // Прогресс при отправке
            if viewModel.isLoading {
                ProgressView("Отправляем...")
                    .padding()
            }
            
            // Ответ
            if !viewModel.responseText.isEmpty {
                ScrollView {
                    Text(viewModel.responseText)
                        .multilineTextAlignment(.center)
                        .padding()
                        .cornerRadius(12)
                }
                .frame(maxHeight: .infinity)
            }
            
            Spacer()
            
            // Кнопка с пульсирующей анимацией
            Button(action: {
                viewModel.toggleRecording()
            }) {
                Image(systemName: viewModel.isRecording ? "mic.fill" : "mic")
                    .font(.largeTitle)
                    .foregroundColor(viewModel.isRecording ? Color.red : Color.blue)
                    .scaleEffect(viewModel.isRecording ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: viewModel.isRecording)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 20)
            .onChange(of: viewModel.isRecording) { newValue in
                animateCircle = newValue
            }
            .padding(.bottom, 20)
            
            // Подпись о записи
            if viewModel.isRecording {
                Text("Запись...")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    WatchVoiceView()
}
