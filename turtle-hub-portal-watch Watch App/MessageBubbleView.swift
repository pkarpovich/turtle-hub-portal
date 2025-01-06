//
//  MessageBubbleView.swift
//  turtle-hub-portal
//
//  Created by Pavel Karpovich on 06/01/2025.
//
import SwiftUI
import MarkdownUI

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
                
                Markdown(messageText)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
