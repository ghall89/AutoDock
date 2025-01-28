import AppKit
import Combine
import SwiftUI

class DisplayManager: ObservableObject {
	@AppStorage("minWidthToShowDock") var minWidthToShowDock = 0.0
	@AppStorage("onlyOnPrimaryDisplay") var onlyOnPrimaryDisplay = true

	@Published var connectedDisplays: [DisplayInfo] = []
	@Published var displayHistory: [DisplayHistoryItem] = []

	init() {
		setupDisplayChangeListener()
		detectDisplay()
		getDisplayHistory()
	}

	private var cancellables = Set<AnyCancellable>()
	
	private func getDisplayHistory() {
		do {
			displayHistory = try loadHistoryFromJSON()
		} catch {
			print("Could not load display history: \(error)")
		}
	}
	
	private func saveDisplayHistory() {
		var newHistory: [DisplayHistoryItem] = displayHistory
		
		connectedDisplays.forEach({ display in
			if let index = newHistory.firstIndex(where: { isSameDisplay(displayOne: $0.displayInfo, displayTwo: display) }) {
				newHistory[index].lastConnected = Date()
			} else {
				newHistory.append(DisplayHistoryItem(displayInfo: display, lastConnected: Date()))
			}
		})
		
		storeHistoryAsJSON(history: newHistory)
	}

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
		if connectedDisplays.map(\.localizedName) == NSScreen.screens.map(\.localizedName) {
			return
		}

		if minWidthToShowDock == 0.0 {
			print("Dock not updated")
		} else if NSScreen.screens.filter({ $0.frame.width >= minWidthToShowDock }).count >= 1 {
			toggleDockVisibility(hidden: false)
		} else {
			toggleDockVisibility(hidden: true)
		}

		for screen in NSScreen.screens {
			let displayToAdd = DisplayInfo(
				id: screen.description,
				localizedName: screen.localizedName,
				frame: screen.frame,
				primaryDisplay: isPrimaryDisplay(screen)
			)
			
			connectedDisplays.append(displayToAdd)
		}
		
		saveDisplayHistory()
	}
	
	

	private func isPrimaryDisplay(_ screen: NSScreen) -> Bool {
		return screen.frame.origin == CGPoint(x: 0, y: 0)
	}
}
