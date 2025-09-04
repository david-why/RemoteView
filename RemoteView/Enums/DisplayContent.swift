//
//  DisplayContentType.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/3.
//

import Foundation

enum DisplayContent: Codable, Hashable {
    case none
    case text(String)
    case off
    case web(URL)
    
    var type: DisplayContentType {
        switch self {
        case .none: .none
        case .text(_): .text
        case .off: .off
        case .web(_): .web
        }
    }
}
