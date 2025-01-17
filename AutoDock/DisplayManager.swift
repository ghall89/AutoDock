import AppKit
import CoreGraphics
import Foundation
import SwiftUI

class DisplayManager: ObservableObject {
	@AppStorage("minWidthToShowDock") private var minWidthToShowDock = 2000.0
	@Published var currentDisplays: [NSScreen] = []

	init() {
		setupDisplayChangeListener()
		detectDisplay()
	}

	private func setupDisplayChangeListener() {
		NotificationCenter.default.addObserver(
			forName: NSApplication.didChangeScreenParametersNotification,
			object: nil,
			queue: .main
		) { _ in
			print("Display configuration changed.")
			self.detectDisplay()
		}
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

		currentDisplays = displays
	}
}
