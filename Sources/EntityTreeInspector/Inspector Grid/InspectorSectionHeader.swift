import SwiftUI

struct InspectorSectionHeader: View {

    private let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 16)
            .padding(.top, 4)
            .padding(.leading, inspectorGridRowPadding)
            .gridCellUnsizedAxes(.horizontal)
    }
}
