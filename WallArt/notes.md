# VisionOS Development

## SwiftUI Attachments and Animations

SwiftUI attachments allow us to display SwiftUI content inside 3D content. Therefore,
SwiftUI attachments are for content that does not live inside the `WindowGroup`; instead, they live alongside our 3D content.

In order to do that, we can call the `RealityView` constructor with a new signature, which entails an additional parameter of type function called `attachments`:

```swift
RealityView { content, attachments in

} attachments: {
    // SwiftUI attachments
}
```

Notice that, in the code above, the signature of the `RealityView` initializer that includes the `attachments` function parameter, now also requires that its first function parameter `make` take in an additional argument under the `attachments` parameter, other than the one argument that we pass over under the `content` parameter.

Eventually, the `AttachmentContent` object being returned by the closure — which we define and pass to the `attachments` parameter of the `RealityView` — will get passed as an argument to the first function parameter of the `RealityView` constructor.

The first function parameter `make`, which takes in two arguments — one we receive under `content` and the other under `attachments`, in the closure definition — is called within the `RealityView` constructor, and passed over the `AttachmentContent` object being returned by the second function parameter (`attachments`) — which we passed a closure to — under the `attachments` parameter.

This is the pseudo code:

```swift
@MainActor
RealityView(_ (inout RealityViewContent, RealityViewAttachments) async -> Void, attachments: () -> AttachmentContent) {
    
    let content = RealityViewContent() 
    let attachmentContent = attachments()
    
    Task {
        make(&content, attachmentContent)
    }
}
```


