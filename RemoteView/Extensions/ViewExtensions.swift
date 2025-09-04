//
//  ViewExtensions.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/4.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func `if`(_ condition: @autoclosure () -> Bool, content: (Self) -> some View) -> some View {
        if condition() {
            content(self)
        } else {
            self
        }
    }
}
