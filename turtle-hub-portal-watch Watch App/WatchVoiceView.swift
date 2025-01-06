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
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    ScrollView {
                        Text(errorMessage)
                            .font(.body)
                            .foregroundColor(.red)
                            .padding()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    Button("Retry") {
                        viewModel.errorMessage = nil
                    }
                }
                .padding()
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
                        Text("Dismiss")
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink(destination: WatchMessagesView()) {
                    Image(systemName: "list.bullet")
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
