import AppKit
import Combine
import SwiftUI

class DisplayManager: ObservableObject {
	@AppStorage("minResolutionToShowDock") var minResolutionToShowDock: CGRect = .zero
	@AppStorage("alsoToggleMenubar") private var alsoToggleMenubar: Bool = false
	@AppStorage("onlyOnPrimaryDisplay") var onlyOnPrimaryDisplay = true

	@Published var connectedDisplays: [DisplayInfo] = []
	@Published var systemEventsPermitted: Bool = true

	var appleScriptService = AppleScriptService()

	init() {
		setupDisplayChangeListener()
		detectDisplay()
	}

	private var cancellables = Set<AnyCancellable>()

	private func setupDisplayChangeListener() {
		NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
			.subscribe(on: DispatchQueue.global(qos: .default))
			.sink { [weak self] _ in
				DispatchQueue.main.async {
					logger.info("Display configuration changed.")
					self?.detectDisplay()
				}
			}
			.store(in: &cancellables)
	}

	private func detectDisplay() {
		guard !NSScreen.screens.isEmpty else {
			logger.info("No displays are connected.")
			connectedDisplays = []
			return
		}

		// check if display parameters actually changed...
		// this is to prevent the app from overriding the user
		// if the Dock's autohide is toggled manually
		logger.info("\(self.connectedDisplays.map(\.localizedName))")
		logger.info("\(NSScreen.screens.map(\.localizedName))")
		if connectedDisplays.map(\.localizedName) == NSScreen.screens.map(\.localizedName) {
			return
		}

		if minResolutionToShowDock == .zero {
			logger.info("Dock not updated")
		} else if NSScreen.screens.filter({ $0.frame.width >= minResolutionToShowDock.width }).count >= 1 {
			toggleDockVisibility(hidden: false)
		} else {
			toggleDockVisibility(hidden: true)
		}

		connectedDisplays = NSScreen.screens.map { screen in
			let displayToAdd = DisplayInfo(
				id: screen.description,
				localizedName: screen.localizedName,
				frame: screen.frame,
				primaryDisplay: isPrimaryDisplay(screen)
			)

			return displayToAdd
		}
	}
	
	private func isSameDisplay(displayOne: DisplayInfo, displayTwo: DisplayInfo) -> Bool {
		return displayOne.localizedName == displayTwo.localizedName
		&& displayOne.frame.width == displayTwo.frame.width
		&& displayOne.frame.height == displayTwo.frame.height
	}

	private func isPrimaryDisplay(_ screen: NSScreen) -> Bool {
		return screen.frame.origin == CGPoint(x: 0, y: 0)
	}

	private func toggleDockVisibility(hidden: Bool) {
		do {
			// don't bother updating dock autohide setting if it matches the new value
			let currentAutoHidePref = try appleScriptService.getDockPreferencesValue(preference: .autohideDock)

			if currentAutoHidePref == hidden || currentAutoHidePref == nil {
				return
			}

			try appleScriptService.setDockPreferencesValue(
				preference: .autohideDock,
				value: hidden
			)

			try appleScriptService.setDockPreferencesValue(
				preference: .autohideMenubar,
				value: hidden,
				condition: alsoToggleMenubar
			)

		} catch {
			logger.error("ERROR: \(error)")
			systemEventsPermitted = false
		}
	}
}
