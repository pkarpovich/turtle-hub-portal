//
//  turtle_hub_portal_widgets.swift
//  turtle-hub-portal-widgets
//
//  Created by Pavel Karpovich on 01/02/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetType: .voice)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), widgetType: .voice)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: Date(), widgetType: .voice)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let widgetType: WidgetType
    
    enum WidgetType {
        case messages, voice
    }
}

struct VoiceWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        Image(systemName: "waveform")
            .resizable()
            .scaledToFit()
            .frame(width: 28, height: 28)
            .foregroundColor(.green)
            .widgetURL(URL(string: "turtlehub://voice"))
    }
}

struct MessagesWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        Image(systemName: "bubble.left.and.bubble.right.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 28, height: 28)
            .foregroundColor(.green)
            .widgetURL(URL(string: "turtlehub://messages"))
    }
}

@main
struct TurtleHubWidgets: WidgetBundle {
    var body: some Widget {
        VoiceWidget()
        MessagesWidget()
    }
}

struct VoiceWidget: Widget {
    let kind: String = "VoiceWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            VoiceWidgetView(entry: entry)
        }
        .configurationDisplayName("Voice input")
        .description("Click to open voice input")
    }
}

struct MessagesWidget: Widget {
    let kind: String = "MessagesWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MessagesWidgetView(entry: entry)
        }
        .configurationDisplayName("Messages")
        .description("Click to open the message list")
    }
}
