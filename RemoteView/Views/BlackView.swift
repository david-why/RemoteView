//
//  BlackView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/4.
//

import SwiftUI

struct BlackView: View {
    @State var originalBrightness = UIScreen.main.brightness
    
    var body: some View {
        Color.black
            .ignoresSafeArea()
            .statusBarHidden()
            .presentationDragIndicator(.hidden)
            .onAppear {
                originalBrightness = UIScreen.main.brightness
                UIScreen.main.brightness = 0.0
            }
            .onDisappear {
                UIScreen.main.brightness = originalBrightness
            }
    }
}

#Preview {
    BlackView()
}
