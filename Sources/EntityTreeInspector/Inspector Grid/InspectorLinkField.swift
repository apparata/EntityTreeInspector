import SwiftUI

struct InspectorLinkField: View {

    private let string: String
    private let url: URL?

    init(_ string: String, url: URL?) {
        self.string = string
        self.url = url
    }

    var body: some View {
        if let url {
            Link(destination: url) {
                InspectorTextValue(string)
            }
        } else {
            InspectorTextValue(string)
        }
    }
}
