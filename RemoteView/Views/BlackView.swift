//
//  BlackView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/4.
//

import SwiftUI

struct BlackView: View {
    var body: some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundStyle(.black)
            .statusBarHidden()
    }
}

#Preview {
    BlackView()
}
