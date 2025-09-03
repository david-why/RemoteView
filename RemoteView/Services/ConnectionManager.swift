//
//  ConnectionManager.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/3.
//

import Foundation
import Combine
import SocketIO

class ConnectionManager {
    let manager: SocketManager
    let socket: SocketIOClient
    
    private let contentPublisher = PassthroughSubject<DisplayContent, Never>()
    var displayContent: AnyPublisher<DisplayContent, Never> {
        AnyPublisher(contentPublisher)
    }
    
    init(url: URL) {
        print("Created ConnectionManager for url \(url)")
        
        self.manager = SocketManager(socketURL: url)
        self.socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }
        socket.on(clientEvent: .error) { data, ack in
            print("Socket.IO error: \(data)")
        }
        socket.on("display") { [weak self] data, ack in
            guard let objectData = data[0] as? Data else {
                print("Display data \(data) is not a string, ignoring packet")
                return
            }
            guard let displayContent = try? JSONDecoder().decode(DisplayContent.self, from: objectData) else {
                print("Display data \(objectData) is not valid JSON, ignoring packet")
                return
            }
            self?.contentPublisher.send(displayContent)
        }
        
        socket.connect()
    }
    
    deinit {
        socket.disconnect()
    }
}
