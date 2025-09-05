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
    @Binding var title: String
    let onWebViewCreated: ((WKWebView) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if (!context.coordinator.isInitialized) {
            context.coordinator.isInitialized = true
            Task { @MainActor in
                print("onWebViewCreated called")
                onWebViewCreated?(uiView)
            }
        }
        if url != context.coordinator.prevURL {
            uiView.clearAndLoad(url: url)
            context.coordinator.prevURL = url
        }
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var isInitialized = false
        var prevURL: URL?
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.canGoBack = webView.canGoBack
            parent.canGoForward = webView.canGoForward
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "title", let webView = object as? WKWebView {
                Task { @MainActor in
                    parent.title = webView.title ?? ""
                }
            }
        }
    }
}
