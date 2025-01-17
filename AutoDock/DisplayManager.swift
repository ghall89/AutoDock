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

		for screen in NSScreen.screens {
			displays.append(screen)
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

	private func toggleDockVisibility(hidden: Bool) {
		// don't bother updating dock autohide setting if it matches the new value
		let readTask = Process()
		readTask.launchPath = "/usr/bin/defaults"
		readTask.arguments = ["read", "com.apple.dock", "autohide"]

		let pipe = Pipe()
		readTask.standardOutput = pipe

		do {
			try readTask.run()
			readTask.waitUntilExit()

			let data = pipe.fileHandleForReading.readDataToEndOfFile()
			if let output = String(data: data, encoding: .utf8) {
				let trimmedOutput = output.trimmingCharacters(in: .whitespacesAndNewlines)
				let dockIsCurrentlyHidden = trimmedOutput == "1"
				print(dockIsCurrentlyHidden)
				if hidden == dockIsCurrentlyHidden {
					print("Dock not updated")
					return
				}
			}
		} catch {
			print("Failed to read Dock settings: \(error)")
		}

		let writeTask = Process()
		writeTask.launchPath = "/usr/bin/defaults"
		writeTask.arguments = ["write", "com.apple.dock", "autohide", "-bool", hidden.description]

		let killDockTask = Process()
		killDockTask.launchPath = "/usr/bin/killall"
		killDockTask.arguments = ["Dock"]

		do {
			try writeTask.run()
			writeTask.waitUntilExit()

			try killDockTask.run()
			killDockTask.waitUntilExit()

			print(hidden ? "Dock is now hidden." : "Dock is now visible.")
		} catch {
			print("Failed to update Dock settings: \(error)")
		}
	}
}
