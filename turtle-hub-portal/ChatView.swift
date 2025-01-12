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
        ZStack {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.messages) { message in
                                messageRow(for: message)
                            }
                        }
                        .padding(16)
                        .onAppear {
                            self.scrollProxy = proxy
                        }
                        .onChange(of: viewModel.messages.count) {
                            scrollToLastMessage(using: proxy)
                        }
                    }
                }
            }
            
            if viewModel.isLoading {
                loaderView
            }
        }
        .background(Color(UIColor.black))
        .navigationTitle("Turtle Hub")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func messageRow(for message: ChatMessage) -> some View {
        HStack {
            if message.isUserMessage {
                Spacer()
                MessageBubbleView(
                    messageText: message.text,
                    isBotMessage: false
                )
            } else {
                MessageBubbleView(
                    messageText: message.text,
                    isBotMessage: true
                )
                Spacer()
            }
        }
    }
    
    private var loaderView: some View {
        Group {
            Color.black
                .ignoresSafeArea()
            ProgressView("Loading messages...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .foregroundColor(.white)
                .scaleEffect(1.5)
        }
    }
    
    private func scrollToLastMessage(using proxy: ScrollViewProxy? = nil) {
        guard let proxy = proxy, let lastMessage = viewModel.messages.last else { return }
        withAnimation {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

#Preview {
    ChatView(viewModel: ChatViewModel())
}
