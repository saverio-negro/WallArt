//
//  AnimationResource-Extension.swift
//  WallArt
//
//  Created by Saverio Negro on 18/04/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

enum AnimationError: Error, LocalizedError {
    case noAnimations
    
    var errorDescription: String? {
        switch self {
        case .noAnimations:
            return NSLocalizedString("Entity does not have any available animations.", comment: "")
        }
    }
}

extension AnimationResource {
    static func fetchAnimation(from entity: Entity) throws -> AnimationResource? {
            
            // Look for an available animation attached to the scene entity
            guard
                let animation = entity.availableAnimations.first
            else {
                throw AnimationError.noAnimations
            }
        
        return animation
    }
}

