//
//  Config.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/3.
//

import Foundation

struct Config {
    private static func value<T>(for key: String) -> T {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? T else {
            fatalError("Value for key \(key) in Info.plist not found or is invalid")
        }
        return value
    }
    
    static var apiBaseURL: URL {
        let urlString: String = value(for: "APIBaseURL")
        guard let url = URL(string: urlString) else {
            fatalError("Invalid API Base URL string: \(urlString)")
        }
        return url
    }
    
    static var socketURL: URL {
        apiBaseURL
    }
}
