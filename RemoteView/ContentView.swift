//
//  ContentView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/3.
//

import SwiftUI

struct ContentView: View {
    @State private var content: DisplayContent = .none
    @State private var connectionManager = ConnectionManager(url: Config.socketURL)
    
    var body: some View {
        VStack {
            contentBody
        }
        .onReceive(connectionManager.displayContent) { content in
            self.content = content
        }
    }
    
    @ViewBuilder var contentBody: some View {
        switch content {
        case .none:
            Image(systemName: "globe")
                .foregroundStyle(Color.accentColor)
                .font(.largeTitle)
                .padding()
            Text("No content displayed yet!")
            Button("Print JSON of display types") {
                debugPrintJSON()
            }
        case .text(let text):
            Text(text)
        }
    }
    
    func debugPrintJSON() {
        let encoder = JSONEncoder()
        print(String(data: try! encoder.encode(DisplayContent.none), encoding: .utf8)!)
        print(String(data: try! encoder.encode(DisplayContent.text("Some Text")), encoding: .utf8)!)
    }
}

#Preview {
    ContentView()
}
