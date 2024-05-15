import SwiftUI

struct InspectorTextValue: View {

    private let string: String
    private let alignment: Alignment

    init(_ string: String, alignment: Alignment = .leading) {
        self.string = string
        self.alignment = alignment
    }

    var body: some View {
        Text(.init(string))
            .lineLimit(1)
            .frame(minWidth: 100, maxWidth: .infinity, alignment: alignment)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(.white.opacity(0.1))
            .cornerRadius(4)
            .padding(.trailing, inspectorGridRowPadding)
    }
}
