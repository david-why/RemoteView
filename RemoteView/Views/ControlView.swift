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
    @State var displayURL = ""
    
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
                        Text("⬛️ Off")
                        Spacer()
                        if displayType == .off {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        displayType = .off
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
                    
                    HStack {
                        Text("🔗 Website")
                        Spacer()
                        if displayType == .web {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if displayType != .web {
                            displayType = .web
                            displayURL = ""
                        }
                    }
                    if displayType == .web {
                        TextField("Enter URL to display...", text: $displayURL)
                            .keyboardType(.URL)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                }
            }
        }
        .navigationTitle("Control")
        .animation(.default, value: displayType)
        .toolbar {
            Button("Send", systemImage: "paperplane") {
                do {
                    try connectionManager.control(room: room, content: getDisplayContent())
                } catch {
                    print("Error sending control message: \(error)")
                }
            }
        }
    }
    
    func getDisplayContent() throws -> DisplayContent {
        switch displayType {
        case .none: return .none
        case .text: return .text(displayText)
        case .off: return .off
        case .web:
            guard let url = URL(string: displayURL) else {
                throw ControlViewError.invalidURL
            }
            return .web(url)
        }
    }
}

enum ControlViewError: Error {
    case invalidURL
}

#Preview {
    NavigationStack {
        ControlView()
    }
}
