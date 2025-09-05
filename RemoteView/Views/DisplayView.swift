//
//  DisplayView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/4.
//

import SwiftUI
import WebKit

struct DisplayView: View {
    let name: String
    
    @StateObject private var connectionManager = ConnectionManager(url: Config.socketURL)
    @State private var originalBrightness = UIScreen.main.brightness
    
    @State private var webView: WKWebView?
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var webViewTitle = ""

    var body: some View {
        VStack {
            contentBody
        }
        .onAppear {
            connectionManager.room = name
            print("Disabling idle timer")
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            if connectionManager.displayContent == .off {
                UIScreen.main.brightness = originalBrightness
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .persistentSystemOverlays(.hidden)
        .if(!isWebView) { $0.toolbar(.hidden, for: .navigationBar) }
        .if(isWebView) {
            $0.toolbar {
                Button("Home", systemImage: "house") {
                    if let webView, case let .webview(url) = connectionManager.displayContent {
                        webView.clearAndLoad(url: url)
                    }
                }
                Button("Back", systemImage: "chevron.backward") {
                    webView?.goBack()
                }
                .disabled(!canGoBack)
                Button("Forward", systemImage: "chevron.forward") {
                    webView?.goForward()
                }
                .disabled(!canGoForward)
            }
        }
    }
    
    var isWebView: Bool {
        if case .webview(_) = connectionManager.displayContent {
            return true
        } else {
            return false
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
        case .webview(let url):
            WebView(url: url, canGoBack: $canGoBack, canGoForward: $canGoForward, title: $webViewTitle) {
                webView = $0
            }
            .id(url)
            .navigationTitle(webViewTitle)
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
