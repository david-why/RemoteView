//
//  WebView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/4.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    let onWebViewCreated: ((WKWebView) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if !context.coordinator.isInitialized {
            let request = URLRequest(url: url)
            uiView.load(request)
            context.coordinator.isInitialized = true
            Task { @MainActor in
                print("onWebViewCreated called")
                onWebViewCreated?(uiView)
            }
        }
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var isInitialized = false
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("DidFinishNavigation \(webView.canGoBack) \(webView.canGoForward)")
            parent.canGoBack = webView.canGoBack
            parent.canGoForward = webView.canGoForward
        }
    }
}
