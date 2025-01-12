//
//  WatchMessages.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 06/01/2025.
//

import SwiftUI

struct WatchMessagesView: View {
    @EnvironmentObject var viewModel: WatchVoiceViewModel
    @State private var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            messageRow(for: message)
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchMessages()
                    self.scrollProxy = proxy
                }
                .onChange(of: viewModel.messages.count) {
                    scrollToLastMessage(using: proxy)
                }
            }
            
            if viewModel.isLoading {
                loadingView
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView{
            Text("Loading messages...")
                .font(.headline)
                .foregroundColor(.accentColor)
        }
        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
        .controlSize(.large)
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
                ).foregroundStyle(.white)
                Spacer()
            }
        }
    }
    
    private var backButton: some View {
        NavigationLink(destination: WatchVoiceView().navigationBarBackButtonHidden(true)) {
            Image(systemName: "chevron.left")
        }
    }
    
    private func scrollToLastMessage(using proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .top)
            }
        }
    }
}
