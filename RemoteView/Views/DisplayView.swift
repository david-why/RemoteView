//
//  DisplayView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/4.
//

import SwiftUI

struct DisplayView: View {
    let name: String
    
    @State private var connectionManager = ConnectionManager(url: Config.socketURL)
    @State private var brightness = UIScreen.main.brightness
    
    var body: some View {
        VStack {
            contentBody
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            connectionManager.room = name
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            if connectionManager.displayContent == .none {
                UIScreen.main.brightness = brightness
            }
        }
        .onChange(of: connectionManager.displayContent) { old, new in
            if new == .off {
                brightness = UIScreen.main.brightness
                UIScreen.main.brightness = 0.0
            } else if old == .off {
                UIScreen.main.brightness = brightness
            }
        }
    }
    
    @ViewBuilder var contentBody: some View {
        switch connectionManager.displayContent {
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
        case .off:
            BlackView()
        }
    }
    
    func debugPrintJSON() {
        let encoder = JSONEncoder()
        let printJSON: (DisplayContent) -> Void = { content in
            print(String(data: try! encoder.encode(content), encoding: .utf8)!)
        }
        printJSON(.none)
        printJSON(.text("Some Text"))
    }
}

#Preview {
    DisplayView(name: "test")
}
