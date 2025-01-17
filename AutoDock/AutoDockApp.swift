import SwiftUI

@main
struct AutoDockApp: App {
	@State var displayConnected: [CGRect] = []
	@Environment(\.openWindow) private var openWindow
	
	init() {
		self.displayConnected = detectDisplay()
	}
	
	var body: some Scene {
		MenuBarExtra("AutoDock", systemImage: "menubar.dock.rectangle", content: {
			ForEach(displayConnected, id: \.self) { display in
				Text(display.width.description)
			}
			Button("Check Active Displays", action: {
				displayConnected = detectDisplay()
			})
			Button("Show Dock", action: {
				toggleDockVisibility(hidden: false)
			})
			Button("Hide Dock", action: {
				toggleDockVisibility(hidden: true)
			})
			Divider()
			Button("Settings...") {
				openWindow(id: "settings")
			}
			Button("Quit AutoDock") {
				NSApplication.shared.terminate(nil)
			}
		})
		
		Window("Settings", id: "settings") {
			SettingsView()
		}
		.windowResizability(.contentSize)
	}
}
