//
//  HomeView.swift
//  RemoteView
//
//  Created by David Wang on 2025/9/3.
//

import SwiftUI

struct HomeView: View {
    @State var path = NavigationPath()
    @State var isAskingDisplayName = false
    
    @AppStorage(DefaultsKeys.room) var name = ""
    @AppStorage(DefaultsKeys.apiURL) var apiURL = Config.defaultApiBaseURL.absoluteString
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                title
                HStack(spacing: 50) {
                    button(label: "Control", style: .green) {
                        path.append(ViewType.control)
                    }
                    button(label: "Display", style: .purple) {
                        name = ""
                        isAskingDisplayName = true
                    }
                }
                .padding()
                DisclosureGroup("\(Image(systemName: "gear")) Settings") {
                    Text("API URL")
                        .font(.headline)
                        .if(!isApiURLValid) { $0.foregroundStyle(.red) }
                    TextField("API URL", text: $apiURL)
                        .multilineTextAlignment(.center)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                .frame(maxWidth: 400)
                .padding(.horizontal)
            }
            .navigationDestination(for: ViewType.self) { type in
                childView(for: type)
            }
            .alert("Please enter the display room name.", isPresented: $isAskingDisplayName) {
                TextField("Room name", text: $name)
                Button("Cancel", role: .cancel) {}
                Button("OK") {
                    path.append(ViewType.display(name: name))
                }
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
    
    @ViewBuilder func button(label: LocalizedStringKey, style: Color, perform: @escaping () -> Void) -> some View {
        Button(action: perform) {
            ZStack {
                Rectangle()
                    .fill(style)
                    .opacity(0.6)
                    .frame(idealWidth: 200, maxWidth: 200, minHeight: 100, idealHeight: 100, maxHeight: 100)
                Text(label)
                    .font(.title2)
                    .foregroundStyle(Color(.label))
            }
        }
    }
    
    @ViewBuilder func childView(for type: ViewType) -> some View {
        switch type {
        case .control: ControlView()
        case .display(let name): DisplayView(name: name)
        }
    }
    
    var isApiURLValid: Bool {
        if let url = URL(string: apiURL) {
            return url.host() != nil
        }
        return false
    }

    enum ViewType: Hashable {
        case control
        case display(name: String)
    }
}

#Preview {
    HomeView()
}
