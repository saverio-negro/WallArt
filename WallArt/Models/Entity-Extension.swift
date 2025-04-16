//
//  Entity-Extension.swift
//  WallArt
//
//  Created by Saverio Negro on 13/04/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

extension Entity {
    
    func rotateEntityAroundYAxisByMatrix(angle: Float) {
        
        let currentTransform = self.transform.matrix
        
        let cos = Float(cos(Angle2D(radians: -1 * angle)))
        let sin = Float(sin(Angle2D(radians: -1 * angle)))
        
        let rotationMatrix: [SIMD4<Float>] = [
            [cos, 0, sin, 0],
            [0, 1, 0, 0],
            [-sin, 0, cos, 0],
            [0, 0, 0, 1]
        ]
        
        let rotationMatrixFloat4x4 = simd_float4x4(rotationMatrix)
        let newTransform = Transform(matrix: currentTransform * rotationMatrixFloat4x4)
        self.transform = newTransform
    }
    
    func rotateEntityAroundYAxisByQuaternion(angle: Float) {
        
        // Get the current transform of the entity
        var currentTransform = self.transform
        
        // Create a quaternion representing a rotation by angle radians around the
        // Y-axis
        let rotation = simd_quatf(angle: angle, axis: [0, 1, 0])
        
        // Compose/Combine the rotation with the current transform's rotation
        // expressed as a unit of quaternion
        currentTransform.rotation = currentTransform.rotation * rotation
        
        // Apply the new transform to the entity
        self.transform = currentTransform
    }
}
