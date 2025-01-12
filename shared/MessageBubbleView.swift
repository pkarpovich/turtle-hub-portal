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
    var isBotMessage: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                bubbleBackground
                messageContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var bubbleBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(gradientBackground)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var messageContent: some View {
        Markdown(messageText)
            .markdownTextStyle() {
                FontFamily(.system())
                FontWeight(.regular)
                ForegroundColor(.white)
                FontSize(14)
            }
            .markdownBlockStyle(\.heading1) { configuration in
                configuration
                    .label
                    .markdownMargin(top: .rem(0), bottom: .rem(0.5))
                    .markdownTextStyle {
                        FontWeight(.semibold)
                        FontSize(14)
                    }
            }
            .markdownBlockStyle(\.heading2) { configuration in
                configuration
                    .label
                    .markdownMargin(top: .rem(0), bottom: .rem(0.5))
                    .markdownTextStyle {
                        FontWeight(.semibold)
                        FontSize(14)
                    }
            }
            .markdownBlockStyle(\.listItem, body: { configuration in
                configuration.label.padding(.vertical, 2).padding(.leading, -12)
            })
            .markdownBlockStyle(\.paragraph) { configuration in
                configuration.label
                    .markdownMargin(top: .rem(0), bottom: .rem(0.2))
            }
            .padding(8)
    }
    
    private var gradientBackground: LinearGradient {
        LinearGradient(
            colors: isBotMessage ? botGradientColors : userGradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var userGradientColors: [Color] {
        [
            Color(red: 0.3, green: 0.4, blue: 0.8),
            Color(red: 0.2, green: 0.2, blue: 0.6)
        ]
    }
    
    private var botGradientColors: [Color] {
        [
            Color(red: 0.2, green: 0.6, blue: 0.2),
            Color(red: 0.1, green: 0.3, blue: 0.3)
        ]
    }
}
