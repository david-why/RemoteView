//
//  ContentView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/3.
//

import SwiftUI

struct ContentView: View {
    @State private var content: DisplayContent = .none
    
    var body: some View {
        VStack {
            contentBody
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
        case .text(let text):
            Text(text)
        }
    }
}

#Preview {
    ContentView()
}
