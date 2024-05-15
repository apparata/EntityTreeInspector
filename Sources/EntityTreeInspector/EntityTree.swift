import RealityKit
import SwiftUI

public struct EntityTree: View {

    public let rootProvider: () -> Entity?

    @State private var treeModel = EntityTreeModel()

    @State private var selectedEntity: Entity?

    public var body: some View {
        HStack {
            List(treeModel.entityTreeSnapshot, children: \.children, selection: $selectedEntity) { entity in
                HStack {
                    if entity.name != "Unnamed" {
                        Text(entity.name)
                            .lineLimit(1)
                    }
                    Text("\(entity.type)")
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                }
                .tag(entity.id)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .contentMargins(20)
            .refreshable {
                treeModel.refreshEntityTreeSnapshot()
            }
            .onAppear {
                treeModel.root = rootProvider()
            }
            EntityDetailsInspector(selectedEntity: $selectedEntity, treeModel: treeModel)
                .padding()
                .background(.ultraThinMaterial)
        }
    }
}
