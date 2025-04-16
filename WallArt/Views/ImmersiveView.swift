//
//  ImmersiveView.swift
//  WallArt
//
//  Created by Saverio Negro on 08/04/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @State var characterEntity: Entity = {
        
        var headAnchor = AnchorEntity(.head)
        headAnchor.position = [0.70, -0.35, -1]
        
        let radians = -30 * Float.pi / 180
        headAnchor.rotateEntityAroundYAxisByMatrix(angle: radians)
        
        return headAnchor
    }()
    
    @State var planeEntity: Entity = {
        let wallAnchor = AnchorEntity(.plane(.vertical, classification: .wall, minimumBounds: SIMD2<Float>(0.6, 0.6)))
        
        let planeMesh = MeshResource.generatePlane(width: 3.5, depth: 2.5, cornerRadius: 0.1)
        let material = TextureResource.loadImageMaterial(imageURL: "think_different")
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [material])
        planeEntity.name = "canvas"
        
        wallAnchor.addChild(planeEntity)
        
        return wallAnchor
    }()

    var body: some View {
        RealityView { content in
            
            do {
                let immersiveEntity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                characterEntity.addChild(immersiveEntity)
                content.add(characterEntity)
                content.add(planeEntity)
                
            } catch {
                print("Error in Reality View's make: \(error.localizedDescription)")
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
