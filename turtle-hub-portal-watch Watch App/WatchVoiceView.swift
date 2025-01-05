//
//  Untitled.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 02/01/2025.
//

import SwiftUI

struct MessageBubbleView: View {
    let messageText: String
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.2, green: 0.6, blue: 0.2),
                                Color(red: 0.1, green: 0.3, blue: 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Text(messageText)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 4)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WatchVoiceView: View {
    @StateObject var viewModel = WatchVoiceViewModel()
    @State private var animateCircle = false
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                VStack {
                    ProgressView(){
                        Text("Fire Away!")
                            .font(.headline)
                            .foregroundColor(.accent)
                    }
                    .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                    .controlSize(.large)
                    .padding()
                }
            }
            else if !viewModel.responseText.isEmpty {
                ScrollView {
                    VStack(alignment: .leading) {
                        MessageBubbleView(
                            messageText: viewModel.responseText
                        )
                    }
                    Button(action: {
                        viewModel.responseText = ""
                        viewModel.toggleRecording()
                    }) {
                        Text("Reply")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Button(action: {
                        viewModel.responseText = ""
                    }) {
                        Text("Close")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
            else {
                VStack {
                    Spacer()
                    
                    if viewModel.isRecording {
                        Text("You're On Air!")
                            .font(.headline)
                            .foregroundColor(.accent)
                    }
                    
                    if viewModel.isRecording {
                        Button(action: {
                            viewModel.stopRecording()
                        }) {
                            Text("Cancel")
                        }
                        .padding(.top, 20)
                    }
                    
                    Button(action: {
                        viewModel.toggleRecording()
                    }) {
                        Image(systemName: viewModel.isRecording ? "mic.fill" : "mic")
                            .font(.largeTitle)
                            .foregroundColor(viewModel.isRecording ? Color.red : Color.accentColor)
                            .scaleEffect(viewModel.isRecording ? 1.0 : 0.8)
                            .animation(viewModel.isRecording ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true) : .default, value: viewModel.isRecording)
                    }
                }
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("StartListening"), object: nil, queue: .main) { _ in
                viewModel.toggleRecording()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("StartListening"), object: nil)
        }
    }
}

#Preview {
    WatchVoiceView()
}
