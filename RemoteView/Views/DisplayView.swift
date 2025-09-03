//
//  DisplayView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/4.
//

import SwiftUI

struct DisplayView: View {
    @State private var connectionManager = ConnectionManager(url: URL(string: "http://localhost:31422")!)
    
    var body: some View {
        VStack {
            contentBody
        }
        .toolbar(.hidden, for: .navigationBar)
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
    DisplayView()
}
