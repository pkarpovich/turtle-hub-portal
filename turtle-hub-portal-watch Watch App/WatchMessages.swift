//
//  WatchMessages.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 06/01/2025.
//

import SwiftUI

struct WatchMessagesView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        if viewModel.isLoading {
                            ProgressView("Loading messages...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                        }
                        
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.isUserMessage {
                                    Spacer()
                                    MessageBubbleView(
                                        messageText: message.text
                                    )
                                }
                                else {
                                    MessageBubbleView(
                                        messageText: message.text
                                    )
                                    Spacer()
                                }
                            }
                        }
                    }
                }
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
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: WatchVoiceView().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
        
    }
}
