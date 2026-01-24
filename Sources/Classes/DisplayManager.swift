import AppKit
import Combine
import SwiftUI

final class DisplayManager: ObservableObject {
	private enum DockPreference: String {
		case autohide
		case autohideMenuBar = "autohide menu bar"
	}

	@AppStorage("minResolutionToShowDock") var minResolutionToShowDock = CGRect.zero
	@AppStorage("alsoToggleMenubar") var alsoToggleMenubar = false

	@Published var connectedDisplays = [DisplayInfo]()
	@Published var systemEventsPermitted = true

	private let dockPreferences = DockPreferencesManager()

	private var cancellables = Set<AnyCancellable>()

	init() {
		setupNotificationListeners()
		checkDisplays()
	}

	private func setupNotificationListeners() {
		let displayChangeNotification = NotificationCenter.default
			.publisher(for: NSApplication.didChangeScreenParametersNotification)

		let wakeFromSleepNotification = NotificationCenter.default.publisher(for: NSWorkspace.didWakeNotification)

		displayChangeNotification
			.merge(with: wakeFromSleepNotification)
			.debounce(for: .milliseconds(250), scheduler: RunLoop.main)
			.sink { [weak self] _ in
				print("Display configuration changed (debounced).")
				self?.checkDisplays()
			}
			.store(in: &cancellables)
	}

	private func checkDisplays() {
		guard !NSScreen.screens.isEmpty else {
			print("No displays are connected.")
			connectedDisplays = []
			return
		}

		// check if display parameters actually changed...
		// this is to prevent the app from overriding the user
		// if the Dock's autohide is toggled manually
		print(connectedDisplays.map(\.localizedName))
		print(NSScreen.screens.map(\.localizedName))
		if connectedDisplays.map(\.localizedName) == NSScreen.screens.map(\.localizedName) {
			return
		}

		if minResolutionToShowDock == .zero {
			print("Dock not updated")
		} else if NSScreen.screens.count(where: { $0.frame.width >= minResolutionToShowDock.width })
			>= 1
		{
			handleVisibility(hidden: false)
		} else {
			handleVisibility(hidden: true)
		}

		connectedDisplays = NSScreen.screens.map { screen in
			DisplayInfo(
				id: screen.description,
				localizedName: screen.localizedName,
				frame: screen.frame,
				primaryDisplay: isPrimaryDisplay(screen),
			)
		}
	}

	private func isPrimaryDisplay(_ screen: NSScreen) -> Bool {
		screen.frame.origin == CGPoint(x: 0, y: 0)
	}

	private func handleVisibility(hidden: Bool) {
		dockPreferences?.setPreference(.autohide, to: hidden)
		if alsoToggleMenubar {
			dockPreferences?.setPreference(.autohideMenuBar, to: hidden)
		}
	}
}
