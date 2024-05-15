# EntityTreeInspector

A SwiftUI window that lets the user inspect a snapshot of a RealityKit entity tree.

To refresh the snapshot, use pull to refresh.

## License

See LICENSE file for license information.

## What Does It Look Like?

![Screenshot of Entity Tree Inspector](https://github.com/apparata/EntityTreeInspector/assets/384210/906f0be1-d7bc-41e2-94bb-2f2ce8de9c5c)

## How To

First add the window scene to your SwiftUI app.

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

Then in a view in your app, open the window with the open window action.

```swift
struct MyView: View {
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        Button {
            openWindow(id: EntityTreeWindow.id)
        } label: {
            Text("Open Entity Tree Inspector")
        }
    }
}
```
