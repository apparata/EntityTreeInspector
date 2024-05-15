import SwiftUI

let inspectorGridRowPadding = 8.0

struct InspectorGrid<Content: View>: View {

    @ViewBuilder let content: () -> Content

    var body: some View {
        ScrollView(.vertical) {
            Grid(horizontalSpacing: 8, verticalSpacing: 16, content: content)
        }
        .scrollBounceBehavior(.always)
    }
}
