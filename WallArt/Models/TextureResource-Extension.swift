//
//  TextureResource-Extension.swift
//  WallArt
//
//  Created by Saverio Negro on 13/04/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

extension TextureResource {
    static func loadImageMaterial(imageURL: String) -> SimpleMaterial {
        do {
            
            let textureResource = try self.load(named: imageURL)
            let texture = MaterialParameters.Texture(textureResource)
            let color = SimpleMaterial.BaseColor(texture: texture)
            
            var material = SimpleMaterial()
            material.color = color
            
            return material
        } catch {
            fatalError(String(describing: error))
        }
    }
}
