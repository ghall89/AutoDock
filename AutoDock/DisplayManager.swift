import AppKit
import Combine
import SwiftUI

class DisplayManager: ObservableObject {
	@AppStorage("minWidthToShowDock") private var minWidthToShowDock = 2000.0
	@Published var currentDisplays: [NSScreen] = []

	init() {
		setupDisplayChangeListener()
		detectDisplay()
	}

	private var cancellables = Set<AnyCancellable>()

	private func setupDisplayChangeListener() {
		NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
			.subscribe(on: DispatchQueue.global(qos: .default))
			.receive(on: DispatchQueue.main)
			.sink { _ in
				print("Display configuration changed.")
				self.detectDisplay()
			}
			.store(in: &cancellables)
	}

	private func detectDisplay() {
		var displays = [NSScreen]()
		guard !NSScreen.screens.isEmpty else {
			print("No displays are connected.")
			currentDisplays = displays
			return
		}

		displays = NSScreen.screens

		// check if display parameters actually changed...
		// this is to prevent the app from overriding the user
		// if the Dock's autohide is toggled manually
		if currentDisplays.map(\.localizedName) == displays.map(\.localizedName) {
			return
		}

		if minWidthToShowDock == 0.0 {
			print("Dock not updated")
		} else if displays.filter({ $0.frame.width >= minWidthToShowDock }).count >= 1 {
			toggleDockVisibility(hidden: false)
		} else {
			toggleDockVisibility(hidden: true)
		}

		self.currentDisplays = displays
	}
}
