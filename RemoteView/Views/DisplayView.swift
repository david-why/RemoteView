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
    @State private var brightness = UIScreen.main.brightness
    
    @State private var webView: WKWebView?
    @State private var canGoBack = false
    @State private var canGoForward = false

    var body: some View {
        VStack {
            contentBody
        }
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
        .onChange(of: connectionManager.displayContent) { new in
            if new == .off {
                brightness = UIScreen.main.brightness
                UIScreen.main.brightness = 0.0
            } else if connectionManager.displayContent == .off {
                UIScreen.main.brightness = brightness
            }
        }
        .navigationBarBackButtonHidden()
        .if(!isWebView) { $0.toolbar(.hidden, for: .navigationBar) }
        .if(isWebView) {
            $0.toolbar {
                Button("Home", systemImage: "house") {
                    if let webView, case let .web(url) = connectionManager.displayContent {
                        webView.reloadFromOrigin()
                        if webView.canGoBack, let item = webView.backForwardList.backList.first {
                            webView.go(to: item)
                        }
                        webView.load(URLRequest(url: url))
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
        if case .web(_) = connectionManager.displayContent {
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
        case .web(let url):
            WebView(url: url, canGoBack: $canGoBack, canGoForward: $canGoForward) {
                webView = $0
            }
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
