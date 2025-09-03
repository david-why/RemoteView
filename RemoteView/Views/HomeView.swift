//
//  HomeView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/3.
//

import SwiftUI

struct HomeView: View {
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                title
                HStack(spacing: 8) {
                    Spacer()
                    button(label: "Control", style: .green) {
                        path.append(ViewType.control)
                    }
                    Spacer()
                    button(label: "Display", style: .purple) {
                        path.append(ViewType.display)
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationDestination(for: ViewType.self) { type in
                childView(for: type)
            }
        }
    }
    
    @ViewBuilder var title: some View {
        Text("RemoteView")
            .font(.largeTitle)
            .bold()
            .foregroundStyle(
                LinearGradient(
                    colors: [.orange, .red],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
    
    @ViewBuilder func button(label: LocalizedStringKey, style: some ShapeStyle, perform: @escaping () -> Void) -> some View {
        Button(action: perform) {
            ZStack {
                Rectangle()
                    .fill(style)
                    .opacity(0.6)
                    .frame(idealWidth: 200, maxWidth: 200, minHeight: 100, idealHeight: 100, maxHeight: 100)
                Text(label)
                    .font(.title2)
                    .foregroundStyle(.primary)
            }
        }
    }
    
    @ViewBuilder func childView(for type: ViewType) -> some View {
        switch type {
        case .control: ControlView()
        case .display: DisplayView()
        }
    }

    enum ViewType {
        case control
        case display
    }
}

#Preview {
    HomeView()
}
