//
//  ContentView.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 01/01/2025.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.isUserMessage {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                        .id(message.id)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .foregroundColor(.black)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                        .id(message.id)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding(16)
                .onAppear {
                    self.scrollProxy = proxy
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                
                HStack {
                    TextField("Write a message...", text: $viewModel.currentText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        viewModel.sendMessage()
                    }) {
                        Text("Send")
                    }
                    .disabled(viewModel.currentText.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Turtle Hub")
        }
    }
}

#Preview {
    ChatView(viewModel: ChatViewModel())
}
