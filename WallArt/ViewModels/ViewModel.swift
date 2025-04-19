//
//  ViewModel.swift
//  WallArt
//
//  Created by Saverio Negro on 12/04/25.
//

import SwiftUI

@Observable
class ViewModel {
    
    var flowState = FlowState.idle
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    
    @MainActor
    func toggleImmersiveSpace() async {
        switch immersiveSpaceState {
            
        case .closed:
            immersiveSpaceState = .inTransition
            
            try! await Task.sleep(nanoseconds: 2_000_000_000)
            switch await ImmersiveSpaceActions.openImmersiveSpace(id: "ImmersiveSpace") {
            
            case .opened:
                break
            case .userCancelled, .error:
                fallthrough
            default:
                immersiveSpaceState = .closed
            }
            
        case .open:
            immersiveSpaceState = .inTransition
            await ImmersiveSpaceActions.dismissImmersiveSpace()
            
        case .inTransition:
            break
        }
    }
}
