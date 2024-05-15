import SwiftUI

struct InspectorToggle: View {

    @Binding private var isOn: Bool

    init(isOn: Binding<Bool>) {
        self._isOn = isOn
    }

    var body: some View {
        HStack {
            Toggle(isOn: $isOn) {
                EmptyView()
            }
            .labelsHidden()
            Spacer()
        }
        .padding(.trailing, inspectorGridRowPadding)
    }
}
