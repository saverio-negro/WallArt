//
//  WallArtApp.swift
//  WallArt
//
//  Created by Saverio Negro on 08/04/25.
//

import SwiftUI

@main
struct WallArtApp: App {
    
    @State var viewModel = ViewModel()

    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(viewModel)
                .onAppear {
                    run()
                }
        }
        .windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(viewModel)
                .onAppear {
                    viewModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    viewModel.immersiveSpaceState = .closed
                }
        }
     }
}

/*
 
 Notes:
 
 By wrapping the `viewModel` variable with
 `@State`, we are persisting the `ViewModel` instance
 contained in `viewModel` throughout the existence of
 our application's life cycle.

 We also use the `@State` property wrapper whenever we want to
 mutate a variable contained in the struct, since structs are,
 by nature, immutable.

 ```swift
 @State var viewModel = ViewModel()
 ```
 
 We are also injecting our persisted instance of type `ViewModel`
 within the environment context of `ContentView`. That way, the
 `ContentView` has access to the same object stored within `viewModel`.
 
 ```swift
 ContentView()
     .environment(viewModel)
 ```
 */
