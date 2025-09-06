//
//  ControlView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/4.
//

import SwiftUI

struct ControlView: View {
    @AppStorage(DefaultsKeys.room) var room = ""
    @State var displayType = DisplayContentType.none
    @AppStorage(DefaultsKeys.controlText) var displayText = ""
    @AppStorage(DefaultsKeys.controlURL) var displayURL = ""
    
    @StateObject var connectionManager = ConnectionManager(url: Config.socketURL)
    
    var body: some View {
        List {
            Section("Room Name") {
                TextField("Enter room name...", text: $room)
            }
            
            if !room.isEmpty {
                Section("Display") {
                    displayContentItem("⬜️ None", type: .none)
                    
                    displayContentItem("⬛️ Off", type: .off)
                    
                    displayContentItem("🔡 Text", type: .text)
                    if displayType == .text {
                        TextField("Enter text to display...", text: $displayText)
                    }
                    
                    displayContentItem("🔗 Website", type: .webview)
                    if displayType == .webview {
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
            Button("Status", systemImage: statusButtonImage) {
                if connectionManager.status == .connecting {
                    connectionManager.socket.connect()
                }
            }
            .tint(statusButtonColor)
            Button("Send", systemImage: "paperplane") {
                do {
                    try connectionManager.control(room: room, content: getDisplayContent())
                } catch {
                    print("Error sending control message: \(error)")
                }
            }
        }
    }
    
    var statusButtonImage: String {
        switch connectionManager.status {
        case .connected: return "checkmark.circle"
        case .connecting: return "arrow.clockwise.circle"
        default: return "xmark.circle"
        }
    }
    
    var statusButtonColor: Color? {
        switch connectionManager.status {
        case .connected: return nil
        case .connecting: return .orange
        default: return .red
        }
    }
    
    @ViewBuilder func displayContentItem(_ label: LocalizedStringKey, type: DisplayContentType, onTapGesture: (() -> Void)? = nil) -> some View {
        HStack {
            Text(label)
            Spacer()
            if displayType == type {
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.accentColor)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTapGesture?()
            displayType = type
        }
    }
    
    func getDisplayContent() throws -> DisplayContent {
        switch displayType {
        case .none: return .none
        case .text: return .text(displayText)
        case .off: return .off
        case .webview:
            guard let url = URL(string: displayURL) else {
                throw ControlViewError.invalidURL
            }
            return .webview(url)
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
