import Sparkle
import SwiftUI

@main
struct AutoDockApp: App {
	@Environment(\.openWindow) private var openWindow
	@StateObject private var displayManager = DisplayManager()

	@State private var showAlert: Bool = false

	private let updaterController: SPUStandardUpdaterController

	init() {
		updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
	}

	var body: some Scene {
		MenuBarExtra("AutoDock", systemImage: "menubar.dock.rectangle", content: {
			if displayManager.systemEventsPermitted == false {
				Text("Unable to get dock status...")
				Text("Please ensure AutoDock permission to automate system events.")
				Divider()
			}
			Button("Settings...", action: openSettings)
			Menu("More") {
				Button("About") {
					NSApp.orderFrontStandardAboutPanel()
				}
				CheckForUpdatesView(updater: updaterController.updater)
				Divider()
				Link("Submit GitHub Issue",
				     destination: URL(string: "https://github.com/ghall89/AutoDock/issues/new?template=Blank+issue")!)
				Link("Support on Ko-Fi",
				     destination: URL(string: "https://ko-fi.com/ghalldev")!)
			}
			Divider()
			Button("Quit AutoDock") {
				NSApplication.shared.terminate(nil)
			}
			.keyboardShortcut("Q", modifiers: .command)
		})

		Window("Settings", id: "settings") {
			SettingsView()
				.environmentObject(displayManager)
				.alert("AutoDock requires permission to automate system events in order to work.", isPresented: $showAlert, actions: {
					Button("Ok", action: {
						showAlert = false
					})
				})
		}
		.windowResizability(.contentSize)
	}

	private func openSettings() {
		openWindow(id: "settings")

		if let window = NSApplication.shared.windows.first(where: { $0.identifier?.rawValue == "settings" }) {
			window.level = .floating
		}
	}
}
