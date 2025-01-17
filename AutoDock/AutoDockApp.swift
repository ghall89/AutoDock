import SwiftUI

@main
struct AutoDockApp: App {
	@Environment(\.openWindow) private var openWindow
	@StateObject private var displayManager = DisplayManager()

	var body: some Scene {
		MenuBarExtra("AutoDock", systemImage: "menubar.dock.rectangle", content: {
			Button("Settings...", action: openSettings)
			Menu("More") {
				Button("About") {
					NSApp.orderFrontStandardAboutPanel()
				}
				Divider()
				Link("Submit GitHub Issue",
						 destination: URL(string: "https://github.com/ghall89/AutoDock/issues/new?template=Blank+issue")!)
			}
			Divider()
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
	
	private func openSettings() {
		openWindow(id: "settings")
		
		if let window = NSApplication.shared.windows.first(where: { $0.identifier?.rawValue == "settings"  }) {
			window.makeKeyAndOrderFront(nil)
			NSApp.activate(ignoringOtherApps: true)
		}
	}
}
