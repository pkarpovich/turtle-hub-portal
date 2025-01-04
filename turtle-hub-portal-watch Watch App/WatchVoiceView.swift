//
//  Untitled.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 02/01/2025.
//

import SwiftUI

extension String {
    var forceCharWrapping: Self {
        self.map({ String($0) }).joined(separator: "\u{200B}")
    }
}

struct MessageBubbleView: View {
    let messageText: String
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.red.opacity(0.8),
                                Color.purple.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomLeading
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Text(messageText.forceCharWrapping)
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
                    ProgressView("Sending message...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.edgesIgnoringSafeArea(.all))
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
                    
                    Button(action: {
                        viewModel.toggleRecording()
                    }) {
                        Image(systemName: viewModel.isRecording ? "mic.fill" : "mic")
                            .font(.largeTitle)
                            .foregroundColor(viewModel.isRecording ? Color.red : Color.blue)
                            .scaleEffect(viewModel.isRecording ? 1.0 : 0.8)
                            .animation(viewModel.isRecording ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true) : .default, value: viewModel.isRecording)
                    }
                    .padding(.bottom, 20)
                    
                    if viewModel.isRecording {
                        Text("Recording...")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                }
            }
        }
    }
}

#Preview {
    WatchVoiceView()
}
