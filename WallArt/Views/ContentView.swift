//
//  ContentView.swift
//  WallArt
//
//  Created by Saverio Negro on 08/04/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    
    @Environment(ViewModel.self) var viewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome to Wall Art in Vision Pro")
                .font(.extraLargeTitle2)
        }
        .padding(50)
        .glassBackgroundEffect()
        .overlay {
            if viewModel.immersiveSpaceState == .inTransition {
                ZStack {
                    Circle()
                        .fill(Color.gray)
                        .glassBackgroundEffect()
                    
                    ProgressView()
                }
            }
        }
        .disabled(viewModel.immersiveSpaceState != .inTransition)
        .task {
            await viewModel.toggleImmersiveSpace()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
