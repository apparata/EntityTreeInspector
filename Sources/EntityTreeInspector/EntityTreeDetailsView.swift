import RealityKit
import simd
import SwiftUI

struct EntityTreeDetailsView: View {

    let entity: Entity

    let treeModel: EntityTreeModel

    var body: some View {
        VStack {
            InspectorGrid {
                switch entity {
                case let modelEntity as ModelEntity:
                    ModelEntityDetails(entity: modelEntity)
                default:
                    EntityDetails(entity: entity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(treeModel)
    }
}

// MARK: EntityDetails

private struct EntityDetails: View {
    let entity: Entity

    var body: some View {
        EntityInfoSection(entity)
        EntityStateSection(entity)
        EntityTransformSection(entity)
    }
}

// MARK: ModelEntityDetails

private struct ModelEntityDetails: View {
    let entity: ModelEntity

    var body: some View {
        EntityInfoSection(entity)
        EntityStateSection(entity)
        EntityTransformSection(entity)
        EntityModelSection(entity)
    }
}

// MARK: EntityInfoSection

private struct EntityInfoSection: View {
    let name: String
    let entityType: String
    let id: String

    private weak var entity: Entity?

    @Environment(EntityTreeModel.self) private var treeModel

    init(_ entity: Entity) {
        self.entity = entity
        name = entity.name.isEmpty ? "Unnamed" : entity.name
        entityType = "\(type(of: entity))"
        id = String(entity.id)
    }

    var body: some View {
        InspectorSectionHeader("Entity")
        TextFieldRow("Name", Binding(get: {
            entity?.name ?? "Unnamed"
        }, set: { newName in
            entity?.name = newName
        }))
        .onSubmit {
            treeModel.refreshEntityTreeSnapshot()
        }
        InfoRow("Type", entityType)
        SecondaryInfoRow("ID", id)
        InspectorDivider()
    }
}

// MARK: EntityStateSection

private struct EntityStateSection: View {
    let entity: Entity

    init(_ entity: Entity) {
        self.entity = entity
    }

    var body: some View {
        InspectorSectionHeader("State")
        ToggleEntityRow("Enabled", entity: entity, keyPath: \.isEnabled)
        BoolRow("Active", entity.isActive)
        InfoRow("Children", String(entity.children.count), alignment: .trailing)
        InspectorDivider()
    }
}

// MARK: EntityTransformSection

private struct EntityTransformSection: View {

    enum Space: Identifiable, CaseIterable, Hashable, CustomStringConvertible {
        case local
        case world

        var id: Self { self }

        var description: String {
            switch self {
            case .local: "Local Space"
            case .world: "World Space"
            }
        }
    }

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 3
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    @State var space: Space = .world

    @Environment(EntityTreeModel.self) var model

    let entity: Entity

    init(_ entity: Entity) {
        self.entity = entity
    }

    var body: some View {
        let worldTransform = entity.convert(transform: entity.transform, to: nil)
        let transform = space == .local ? entity.transform : worldTransform
        let position: SIMD3<Float> = transform.translation
        let euler: SIMD3<Float> = transform.euler
        let scale: SIMD3<Float> = transform.scale

        InspectorSectionPickerHeader("Transform", value: $space)

        GridRow(alignment: .top) {
            Image(systemName: "move.3d")
                .foregroundStyle(.secondary)
                .padding(.leading, inspectorGridRowPadding)
                .padding(.top, 6)
                .gridColumnAlignment(.trailing)
            HStack {
                spaceValueField(
                    local: Binding(get: { () -> Float in
                        return entity.transform.translation.x
                    }, set: { value, _ in
                        entity.transform.translation.x = value
                    }),
                    world: position.x,
                    subtitle: "x"
                )
                spaceValueField(
                    local: Binding(get: { () -> Float in
                        return entity.transform.translation.y
                    }, set: { value, _ in
                        entity.transform.translation.y = value
                    }),
                    world: position.y,
                    subtitle: "y"
                )
                spaceValueField(
                    local: Binding(get: { () -> Float in
                        return entity.transform.translation.z
                    }, set: { value, _ in
                        entity.transform.translation.z = value
                    }),
                    world: position.z,
                    subtitle: "z"
                )
            }
            .padding(.trailing, inspectorGridRowPadding)
        }

        GridRow(alignment: .top) {
            Image(systemName: "rotate.3d")
                .foregroundStyle(.secondary)
                .padding(.leading, inspectorGridRowPadding)
                .padding(.top, 6)
                .gridColumnAlignment(.trailing)
            HStack {
                spaceValue(euler.x, subtitle: "x")
                spaceValue(euler.y, subtitle: "y")
                spaceValue(euler.z, subtitle: "z")
            }
            .padding(.trailing, inspectorGridRowPadding)
        }

        GridRow(alignment: .top) {
            Image(systemName: "scale.3d")
                .foregroundStyle(.secondary)
                .padding(.leading, inspectorGridRowPadding)
                .padding(.top, 6)
                .gridColumnAlignment(.trailing)
            HStack {
                spaceValueField(
                    local: Binding(get: { () -> Float in
                        return entity.transform.scale.x
                    }, set: { value, _ in
                        entity.transform.scale.x = value
                    }),
                    world: scale.x,
                    subtitle: "x"
                )
                spaceValueField(
                    local: Binding(get: { () -> Float in
                        return entity.transform.scale.y
                    }, set: { value, _ in
                        entity.transform.scale.y = value
                    }),
                    world: scale.y,
                    subtitle: "y"
                )
                spaceValueField(
                    local: Binding(get: { () -> Float in
                        return entity.transform.scale.z
                    }, set: { value, _ in
                        entity.transform.scale.z = value
                    }),
                    world: scale.z,
                    subtitle: "z"
                )
            }
            .padding(.trailing, inspectorGridRowPadding)
        }

        InspectorDivider()
    }

    @ViewBuilder private func spaceValueField(local: Binding<Float>, world: Float, subtitle: String) -> some View {
        VStack(spacing: 0) {
            if space == .local {
                TextField("", value: local, formatter: formatter)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)
                    .labelsHidden()
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity)
                    .background(.white.opacity(0.05))
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            } else {
                Text("\(formatter.string(from: NSNumber(value: world)) ?? "--")")
                    .lineLimit(1)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity)
                    .background(.white.opacity(0.1))
                    .cornerRadius(4)
            }
            Text(subtitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }

    @ViewBuilder private func spaceValue(_ value: Float, subtitle: String) -> some View {
        VStack(spacing: 0) {
            Text("\(formatter.string(from: NSNumber(value: value)) ?? "--")")
                .lineLimit(1)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .background(.white.opacity(0.1))
                .cornerRadius(4)
            Text(subtitle)
                .lineLimit(1)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: EntityModelSection

private struct EntityModelSection: View {
    let entity: ModelEntity

    @Environment(EntityTreeModel.self) var model

    init(_ entity: ModelEntity) {
        self.entity = entity
    }

    var body: some View {
        if let modelComponent = entity.model {
            let modelSummary = model.computeModelStats(for: modelComponent)

            InspectorSectionHeader("Model Geometry")
            InfoRow("Parts", "\(modelSummary.totalPartCount)", alignment: .trailing)
            InfoRow("Triangles", "\(modelSummary.totalTriangleCount)", alignment: .trailing)
            InfoRow("Materials", "\(modelSummary.materialCount)", alignment: .trailing)
        }
    }
}

// MARK: InfoRow

private struct InfoRow: View {
    private let title: String
    private let details: String
    private let alignment: Alignment

    init(_ title: String, _ details: String, alignment: Alignment = .leading) {
        self.title = title
        self.details = details
        self.alignment = alignment
    }

    var body: some View {
        GridRow {
            InspectorLabel(title)
            InspectorTextValue(details, alignment: alignment)
        }
    }
}

// MARK: TextFieldRow

private struct TextFieldRow: View {
    private let title: String
    @Binding private var details: String
    private let alignment: Alignment

    init(_ title: String, _ details: Binding<String>, alignment: Alignment = .leading) {
        self.title = title
        self._details = details
        self.alignment = alignment
    }

    var body: some View {
        GridRow {
            InspectorLabel(title)
            InspectorTextField($details, alignment: alignment)
        }
    }
}

// MARK: SecondaryInfoRow

private struct SecondaryInfoRow: View {
    private let title: String
    private let details: String
    private let alignment: Alignment

    init(_ title: String, _ details: String, alignment: Alignment = .leading) {
        self.title = title
        self.details = details
        self.alignment = alignment
    }

    var body: some View {
        GridRow {
            InspectorLabel(title)
            InspectorTextValue(details, alignment: alignment)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: BoolRow

private struct BoolRow: View {
    private let title: String
    private let value: Bool

    init(_ title: String, _ value: Bool) {
        self.title = title
        self.value = value
    }

    var body: some View {
        GridRow {
            InspectorLabel(title)
            InspectorTextValue(value ? "Yes" : "No")
                .foregroundColor(value ? .green : .secondary)
        }
    }
}

// MARK: ToggleRow

private struct ToggleEntityRow: View {
    private let title: String
    private let entity: Entity
    private let keyPath: ReferenceWritableKeyPath<Entity, Bool>
    @State private var isOn: Bool

    init(_ title: String, entity: Entity, keyPath: ReferenceWritableKeyPath<Entity, Bool>) {
        self.title = title
        self.entity = entity
        self.keyPath = keyPath
        self._isOn = State(wrappedValue: entity[keyPath: keyPath])
    }

    var body: some View {
        GridRow {
            InspectorLabel(title)
            InspectorToggle(isOn: $isOn)
                .onChange(of: isOn) { _, newValue in
                    entity[keyPath: keyPath] = newValue
                }
        }
    }
}

private extension Transform {
    var euler: SIMD3<Float> {
        matrix.euler
    }
}

private extension simd_float4x4 {
    var euler: SIMD3<Float> {
        SIMD3(
            x: asin(-self[2][1]),
            y: atan2(self[2][0], self[2][2]),
            z: atan2(self[0][1], self[1][1])
        )
    }
}
