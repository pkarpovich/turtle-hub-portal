//
//  Untitled.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 02/01/2025.
//

import SwiftUI

struct WatchVoiceView: View {
    @EnvironmentObject var viewModel: WatchVoiceViewModel
    @State private var animateRecording = false
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage)
            } else if !viewModel.responseText.isEmpty {
                responseView
            } else {
                recordingView
            }
        }
        .onAppear {
            if viewModel.isRecording {
                animateRecording = true
            }
        }
        .onChange(of: viewModel.isRecording) { _, isRecording in
            withAnimation {
                animateRecording = isRecording
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink(destination: WatchMessagesView()
                    .environmentObject(viewModel)
                ) {
                    Image(systemName: "list.bullet")
                }
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView {
                Text("Fire Away!")
                    .font(.headline)
                    .foregroundColor(.accentColor)
            }
            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
            .controlSize(.large)
            .padding()
        }
    }
    
    private func errorView(_ errorMessage: String) -> some View {
        VStack {
            ScrollView {
                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.red)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button("Retry") {
                viewModel.errorMessage = nil
            }
            .padding()
        }
    }
    
    private var responseView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                MessageBubbleView(messageText: viewModel.responseText, isBotMessage: true)
            }
            Button(action: {
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
                Text("Dismiss")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
    
    private var recordingView: some View {
        VStack {
            Spacer()
            
            if viewModel.isRecording {
                Text("You're On Air!")
                    .font(.headline)
                    .foregroundColor(.accentColor)
            }
            
            if viewModel.isRecording {
                Button(action: {
                    viewModel.stopRecording()
                }) {
                    Text("Cancel")
                }
            }
            
            Button(action: {
                viewModel.toggleRecording()
            }) {
                Image(systemName: animateRecording ? "mic.fill" : "mic")
                    .font(.largeTitle)
                    .foregroundColor(animateRecording ? .red : .accentColor)
                    .scaleEffect(animateRecording ? 1.0 : 0.8)
                    .animation(
                        animateRecording
                        ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true)
                        : .default,
                        value: animateRecording
                    )
            }
        }
    }
}

#Preview {
    WatchVoiceView()
}
