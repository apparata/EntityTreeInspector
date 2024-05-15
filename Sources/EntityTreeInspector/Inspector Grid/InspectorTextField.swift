import SwiftUI

struct InspectorTextField: View {

    @Binding private var string: String
    private let alignment: Alignment

    init(_ string: Binding<String>, alignment: Alignment = .leading) {
        self._string = string
        self.alignment = alignment
    }

    var body: some View {
        TextField("", text: $string)
            .textFieldStyle(.plain)
            .lineLimit(1)
            .frame(minWidth: 100, maxWidth: .infinity, alignment: alignment)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(.white.opacity(0.05))
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .padding(.trailing, inspectorGridRowPadding)
    }
}
