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
    @State private var webViewCounter = 0

    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            contentBody
                .if(connectionManager.status == .connecting) {
                    $0.navigationTitle(Text("🔄 Reconnecting..."))
                }
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
        .onChange(of: scenePhase) { new in
            if new == .active {
                print("Returned to foreground, disabling idle timer")
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
        .onChange(of: connectionManager.displayContent) { new in
            if new.type == .webview {
                webViewCounter += 1
            }
        }
        .onChange(of: webViewCounter) { _ in
            canGoBack = false
            canGoForward = false
            webViewTitle = ""
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
                .padding(.bottom)
            Text("Please display content from the Control section of the app, using the same room name you entered.")
                .multilineTextAlignment(.center)
        case .text(let text):
            Text(text)
        case .off:
            BlackView()
        case .webview(let url):
            WebView(url: url, canGoBack: $canGoBack, canGoForward: $canGoForward, title: $webViewTitle) {
                webView = $0
            }
            .id(webViewCounter)
            .navigationTitle(webViewTitle)
            .toolbar {
                Button("Home", systemImage: "house") {
                    webViewCounter += 1
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
}

#Preview {
    DisplayView(name: "test")
}
