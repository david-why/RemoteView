//
//  ConnectionManager.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/3.
//

import Foundation
import Combine
import SocketIO

@Observable
class ConnectionManager {
    let manager: SocketManager
    let socket: SocketIOClient
    var room: String? = nil {
        didSet {
            if let room {
                socket.emit("setname", room)
            }
        }
    }
    
    var displayContent: DisplayContent = .none
    
    init(url: URL) {
        print("Created ConnectionManager for url \(url)")
        
        self.manager = SocketManager(socketURL: url, config: [.forceWebsockets(true)])
        self.socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("Socket connected")
            if let room = self?.room {
                self?.socket.emit("setname", room)
            }
        }
        socket.on(clientEvent: .error) { data, ack in
            print("Socket.IO error: \(data)")
        }
        socket.on("display") { [weak self] data, ack in
            guard let objectData = data[0] as? [String: Any] else {
                print("Display data \(data) is not a dictionary, ignoring packet")
                return
            }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: objectData, options: []) else {
                print("Failed to convert dictionary \(objectData) to JSON data")
                return
            }   
            guard let displayContent = try? JSONDecoder().decode(DisplayContent.self, from: jsonData) else {
                print("Display data \(objectData) is not a valid DisplayContent, ignoring packet")
                return
            }
            self?.displayContent = displayContent
        }
        
        socket.connect()
    }
    
    deinit {
        print("Destroyed ConnectionManager")
        socket.disconnect()
    }
    
    func control(room: String, content: DisplayContent) throws {
        let jsonData = try JSONEncoder().encode(content)
        guard let objectData = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            throw ConnectionManagerError.failedToConvertToJSON
        }
        socket.emit("control", room, objectData)
    }
}

enum ConnectionManagerError: Error {
    case failedToConvertToJSON
}
