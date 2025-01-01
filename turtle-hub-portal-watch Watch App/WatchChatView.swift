//
//  ContentView.swift
//  turtle-hub-portal-watch Watch App
//
//  Created by Pavel Karpovich on 01/01/2025.
//

import SwiftUI

struct WatchChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(viewModel.messages) { message in
                    if message.isUserMessage {
                        HStack {
                            Spacer()
                            Text(message.text)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.blue)
                                .cornerRadius(8)
                                .id(message.id)
                        }
                    } else {
                        HStack {
                            Text(message.text)
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(6)
                                .background(Color.white)
                                .cornerRadius(8)
                                .id(message.id)
                            Spacer()
                        }
                    }
                }
            }
            .onChange(of: viewModel.messages.count) { _ in
                if let lastMessage = viewModel.messages.last {
                    withAnimation {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            HStack {
                TextField("Text", text: $viewModel.currentText)
                Button("OK") {
                    viewModel.sendMessage()
                }
            }
            .navigationTitle("Watch Chat")
        }
    }
}

#Preview {
    WatchChatView(viewModel: ChatViewModel())
}
