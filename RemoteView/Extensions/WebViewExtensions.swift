//
//  WebViewExtensions.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/6.
//

import Foundation
import WebKit

extension WKWebView {
    func clearAndLoad(url: URL) {
        reloadFromOrigin()
        if canGoBack, let item = backForwardList.backList.first {
            go(to: item)
        }
        load(URLRequest(url: url))
    }
}
