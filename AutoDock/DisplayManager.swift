import AppKit
import Combine
import SwiftUI

class DisplayManager: ObservableObject {
	@AppStorage("minResolutionToShowDock") var minResolutionToShowDock: CGRect = .zero
	@AppStorage("onlyOnPrimaryDisplay") var onlyOnPrimaryDisplay = true

	@Published var connectedDisplays: [DisplayInfo] = []
//	@Published var displayHistory: [DisplayHistoryItem] = []
	@Published var systemEventsPermitted: Bool = true

	init() {
		setupDisplayChangeListener()
		detectDisplay()
//		getDisplayHistory()
	}

	private var cancellables = Set<AnyCancellable>()

//	private func getDisplayHistory() {
//		do {
//			displayHistory = try loadHistoryFromJSON()
//		} catch {
//			print("Could not load display history: \(error)")
//		}
//	}

//	private func saveDisplayHistory() {
//		var newHistory: [DisplayHistoryItem] = displayHistory
//
//		connectedDisplays.forEach({ display in
//			if let index = newHistory.firstIndex(where: { isSameDisplay(displayOne: $0.displayInfo, displayTwo: display) }) {
//				newHistory[index].lastConnected = Date()
//			} else {
//				newHistory.append(DisplayHistoryItem(displayInfo: display, lastConnected: Date()))
//			}
//		})
//
//		storeHistoryAsJSON(history: newHistory)
//	}

	private func setupDisplayChangeListener() {
		NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
			.subscribe(on: DispatchQueue.global(qos: .default))
			.sink { [weak self] _ in
				DispatchQueue.main.async {
					print("Display configuration changed.")
					self?.detectDisplay()
				}
			}
			.store(in: &cancellables)
	}

	private func detectDisplay() {
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

//		saveDisplayHistory()
	}

	private func isPrimaryDisplay(_ screen: NSScreen) -> Bool {
		return screen.frame.origin == CGPoint(x: 0, y: 0)
	}

	private func toggleDockVisibility(hidden: Bool) {
		// don't bother updating dock autohide setting if it matches the new value
		let currentAutoHidePref = getDockAutohidePref()

		if currentAutoHidePref == nil {
			return
		}

		if currentAutoHidePref != hidden {
			let script = """
				tell application "System Events"
				 set autohide of dock preferences to \(hidden.description)
				end tell
				"""

			do {
				_ = try runAppleScript(script: script)
			} catch {
				print(error)
			}
		}
	}

	private func getDockAutohidePref() -> Bool? {
		let script = """
			tell application "System Events"
			 get autohide of dock preferences
			end tell
			"""

		do {
			if let boolString = try runAppleScript(script: script) {
				return boolString == "true"
			}
		} catch {
			systemEventsPermitted = false
		}

		return nil
	}
}
