import SwiftUI

struct InspectorSectionPickerHeader<T: CaseIterable & Identifiable & CustomStringConvertible & Hashable>: View where T.AllCases: RandomAccessCollection {

    private let title: String
    @Binding private var value: T

    init(_ title: String, value: Binding<T>) {
        self.title = title
        self._value = value
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 16)
                .padding(.top, 4)
                .padding(.leading, inspectorGridRowPadding)
            Picker("", selection: $value) {
                ForEach(T.allCases) { entry in
                    Text(entry.description)
                        .tag(entry)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .frame(width: 160)
            .padding(.trailing, inspectorGridRowPadding)
        }
        .gridCellUnsizedAxes(.horizontal)
    }
}
