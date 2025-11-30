import SwiftUI

struct ContentView: View {
    let listItems: [String] = [
        "One",
        "Two",
        "Three",
        "Four",
    ]

    var body: some View {
        NavigationSplitView(
            sidebar: {
                List(listItems, id: \.self) { item in
                    Label(item, systemImage: "document")
                }
            },
            detail: {
                Text("Hello, World!")
                    .padding(16)
            }
        )

    }
}
