import Foundation
import RealityKit
import SwiftUI
import Combine

struct ModelGeometrySummary {
    let totalPartCount: Int
    let totalTriangleCount: Int
    let materialCount: Int
}

struct EntityTreeNode: Identifiable, Hashable {
    var id: Entity { entity }
    let name: String
    let type: String
    let isEnabled: Bool
    var children: [EntityTreeNode]?
    var entity: Entity
}

@Observable class EntityTreeModel {

    weak var root: Entity? {
        didSet {
            refreshEntityTreeSnapshot()
        }
    }

    var entityTreeSnapshot: [EntityTreeNode] = []

    init() {
        //
    }

    // MARK: Refresh Tree Snapshot

    func refreshEntityTreeSnapshot() {
        guard let root else {
            entityTreeSnapshot = []
            return
        }
        DispatchQueue.main.async {
            self.entityTreeSnapshot = self.buildEntityTreeSnapshot(root: root)
        }
    }

    // MARK: Build Entity Tree Snapshot

    func buildEntityTreeSnapshot(root: Entity) -> [EntityTreeNode] {
        var nodes: [EntityTreeNode] = []
        nodes.append(buildEntityTreeSnapshot(root))
        return nodes
    }

    func buildEntityTreeSnapshot(_ entity: Entity) -> EntityTreeNode {
        var children: [EntityTreeNode] = []
        for childEntity in entity.children {
            let child = buildEntityTreeSnapshot(childEntity)
            children.append(child)
        }
        let node = EntityTreeNode(
            name: entity.name.isEmpty ? "Unnamed" : entity.name,
            type: "\(type(of: entity))",
            isEnabled: entity.isEnabled,
            children: children.isEmpty ? nil : children,
            entity: entity
        )
        return node
    }

    // MARK: Entity by ID

    func entityNodeByID(_ id: Entity.ID, root: EntityTreeNode? = nil) -> EntityTreeNode? {
        let nodes: [EntityTreeNode]
        if let root {
            if root.entity.id == id {
                return root
            }
            nodes = root.children ?? []
        } else {
            nodes = entityTreeSnapshot
        }
        for node in nodes {
            if let foundNode = entityNodeByID(id, root: node) {
                return foundNode
            }
        }
        return nil
    }

    // MARK: Model

    func computeModelStats(for model: ModelComponent) -> ModelGeometrySummary {
        let meshResource = model.mesh
        let models = meshResource.contents.models

        let materialCount = meshResource.expectedMaterialCount

        var totalPartCount = 0
        var totalTriangleCount = 0

        for model in models {
            totalPartCount += model.parts.count
            for part in model.parts {
                totalTriangleCount += (part.triangleIndices?.count ?? 0) / 3
            }
        }

        return ModelGeometrySummary(totalPartCount: totalPartCount,
                                    totalTriangleCount: totalTriangleCount,
                                    materialCount: materialCount)
    }
}
