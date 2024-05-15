# EntityTreeInspector

A SwiftUI window that lets the user inspect a RealityKit entity tree.

## License

See LICENSE file for license information.

## How To

```swift
@main 
@MainActor struct MyApp: App {

    @Struct private var myModel: MyModel

    var body: some SwiftUI.Scene {

        // Debugging window showing the entity tree.
        EntityTreeWindow {
            // Return the root entity of your entity tree here.
            myModel.rootEntity
        }
    }
}
```
