import SwiftUI
import RealityKit

public struct EntityTreeWindow: SwiftUI.Scene {

    public static let id: String = "EntityTreeWindow"
    public static let defaultWidth: CGFloat = 800
    public static let defaultHeight: CGFloat = 800

    public let rootProvider: () -> Entity?

    public var body: some SwiftUI.Scene {
        WindowGroup(id: Self.id) {
            EntityTree(rootProvider: rootProvider)
        }
        .windowResizability(.contentSize)
        .defaultSize(width: Self.defaultWidth, height: Self.defaultHeight)
    }
}
