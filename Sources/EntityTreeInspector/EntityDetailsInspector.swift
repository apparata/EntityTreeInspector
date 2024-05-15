import RealityKit
import SwiftUI

struct EntityDetailsInspector: View {

    @Binding var selectedEntity: Entity?

    let treeModel: EntityTreeModel

    var body: some View {
        VStack {
            if let entity = selectedEntity {
                ScrollView(.vertical) {
                    EntityTreeDetailsView(entity: entity, treeModel: treeModel)
                }
            } else {
                ContentUnavailableView {
                    Text("No Selection")
                        .font(.system(.title3))
                }
            }
        }
        .frame(maxWidth: 400, maxHeight: .infinity)
    }
}
