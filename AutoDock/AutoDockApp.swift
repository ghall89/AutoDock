import SwiftUI

@main
struct AutoDockApp: App {
	@Environment(\.openWindow) private var openWindow
	@StateObject private var displayManager = DisplayManager()

	var body: some Scene {
		MenuBarExtra("AutoDock", systemImage: "menubar.dock.rectangle", content: {
			Button("Settings...") {
				openWindow(id: "settings")
			}
			Button("Quit AutoDock") {
				NSApplication.shared.terminate(nil)
			}
		})

		Window("Settings", id: "settings") {
			SettingsView()
				.environmentObject(displayManager)
		}
		.windowResizability(.contentSize)
	}
}
