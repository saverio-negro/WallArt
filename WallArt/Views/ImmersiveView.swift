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
    
    @Environment(ViewModel.self) var viewModel
    
    @State private var inputText = ""
    @State public var showTextField = false
    
    @State private var assistant: Entity? = nil
    @State private var waveAnimation: AnimationResource? = nil
    
    var attachment: some View {
        // SwiftUI attachments
        VStack {
            Text(inputText)
                .frame(width: 600, alignment: .leading)
                .font(.extraLargeTitle2)
                .fontWeight(.regular)
                .padding(40)
                .glassBackgroundEffect()
        }
        // Show text field when character gets tapped
        .opacity(showTextField ? 1 : 0)
    }
    
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
        
        RealityView { content, attachments  in

            do {

                // Load in the character entity
                let immersiveEntity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                
                characterEntity.addChild(immersiveEntity)
                
                content.add(characterEntity)
                content.add(planeEntity)

                // Load in the SwiftUI Attachment
                guard let attachmentEntity = attachments.entity(for: "attachment") else {
                    fatalError("Failed to create attachment entity.")
                }
                attachmentEntity.position = SIMD3<Float>(0, 0.6, 0)
                let radians = 30 * Float.pi / 180
                attachmentEntity.rotateEntityAroundYAxisByMatrix(angle: radians)
                characterEntity.addChild(attachmentEntity)
                
                // Load in `characterAnimationsSceneEntity` containing models holding a specific character animation
                let characterAnimationsSceneEntity = try await Entity(named: "CharacterAnimations", in: realityKitContentBundle)
                
                // Load in `waveModel` and `assistant` entities
                guard let waveModel = characterAnimationsSceneEntity.findEntity(named: "wave_model") else { return }
                guard let assistant = characterEntity.findEntity(named: "assistant") else { return }
                
                // Load in wave animation from `waveModel` entity
                guard let waveAnimationResource = try AnimationResource.fetchAnimation(from: waveModel) else { return }
                
                // Load in idle animation from `assistant` entity
                guard let idleAnimationResource = try AnimationResource.fetchAnimation(from: assistant) else { return }
                
                // Create an animation resource that plays a collection of animations in a specified sequence
                let waveAnimation = try AnimationResource.sequence(
                    with: [waveAnimationResource, idleAnimationResource.repeat()]
                )
                
                // Play idle animation on `assistant` entity as soon as the `RealityView` loads up
                assistant.playAnimation(idleAnimationResource.repeat())
                
                self.assistant = assistant
                self.waveAnimation = waveAnimation
                
            } catch {
                print("Error in Reality View's make: \(error.localizedDescription)")
            }
        } attachments: {
            // Set a unique tag value for the `Attachment` object
            // wrapping the content of type `View`
            Attachment(id: "attachment") {
                self.attachment
            }
        }
        .gesture(
            SpatialTapGesture().targetedToAnyEntity().onEnded { _ in
                viewModel.flowState = .intro
            }
        )
        .onChange(of: viewModel.flowState) { _, newValue in
            switch newValue {
            case .idle:
                break
            case .intro:
                Task { await playIntroSequence() }
            case .projectileFlying:
                break
            case .updateWallArt:
                break
            }
        }
    }
    
    // Animate prompt text in the SwiftUI attachment's `Text` view
    func animatePromptText(text: String) async {
        
        // Empty input text
        inputText = ""
        
        let words = text.split(separator: " ")
        
        // Type the title out after 0.3 second
        let delay = getNanosecondsFrom(seconds: 0.3)
        try! await Task.sleep(nanoseconds: delay)
        
        for word in words {
            let nanoseconds = getNanosecondsFrom(seconds: Double.random(in: 0.1...0.3))
            try! await Task.sleep(nanoseconds: nanoseconds)
            
            inputText += String(word) + " "
        }
    }
    
    // Get nanoseconds from seconds
    func getNanosecondsFrom(seconds: Double) -> UInt64 {
        return UInt64(seconds * pow(10, 9))
    }
    
    // Show `Text` view and animate character upon entering the `.intro` app's state
    func showTextAndWaveAnimate() async {
        
        // Show dialog box
        if !showTextField {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                showTextField.toggle()
            }
        }
        
        guard let assistant = self.assistant, let waveAnimation = self.waveAnimation else { return }
        
        assistant.playAnimation(waveAnimation.repeat(count: 1))
    }
    
    func playIntroSequence() async {
        
        // List of Texts
        let texts = [
            "Hey :), let's create some doodle art\n with the Vision pro. Are you ready?",
            "Awesome! Draw something and\n watch it come alive."
        ]
        
        // Run tasks in parallel
        async let showTextAndWaveAnimate: Void = showTextAndWaveAnimate()
        async let animatePromptText: Void = animatePromptText(text: texts[0])
        
        _ = await (showTextAndWaveAnimate, animatePromptText)
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
