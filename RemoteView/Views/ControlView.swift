//
//  ControlView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/4.
//

import SwiftUI

struct ControlView: View {
    @State var room = "1"
    @State var displayType = DisplayContentType.none
    @State var displayText = ""
    
    @State var connectionManager = ConnectionManager(url: Config.socketURL)
    
    var body: some View {
        List {
            Section("Room Name") {
                TextField("Enter room name...", text: $room)
            }
            
            if !room.isEmpty {
                Section("Display") {
                    HStack {
                        Text("⬜️ None")
                        Spacer()
                        if displayType == .none {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        displayType = .none
                    }
                    
                    HStack {
                        Text("🔡 Text")
                        Spacer()
                        if displayType == .text {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if displayType != .text {
                            displayType = .text
                            displayText = ""
                        }
                    }
                    if displayType == .text {
                        TextField("Enter text to display...", text: $displayText)
                    }
                }
            }
        }
        .navigationTitle("Control")
        .animation(.default, value: displayType)
        .toolbar {
            Button("Send", systemImage: "paperplane") {
                do {
                    try connectionManager.control(room: room, content: displayContent)
                } catch {
                    print("Error sending control message: \(error)")
                }
            }
        }
    }
    
    var displayContent: DisplayContent {
        switch displayType {
        case .none: .none
        case .text: .text(displayText)
        case .off: .off
        }
    }
}

#Preview {
    NavigationStack {
        ControlView()
    }
}
