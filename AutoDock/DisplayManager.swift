import AppKit
import Combine
import SwiftUI

class DisplayManager: ObservableObject {
	@AppStorage("minWidthToShowDock") private var minWidthToShowDock = 2000.0
	@Published var currentDisplays: [DisplayInfo] = []

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
					print("Display configuration changed.")
					self?.detectDisplay()
				}
			}
			.store(in: &cancellables)
	}

	private func detectDisplay() {
		guard !NSScreen.screens.isEmpty else {
			print("No displays are connected.")
			currentDisplays = []
			return
		}

		// check if display parameters actually changed...
		// this is to prevent the app from overriding the user
		// if the Dock's autohide is toggled manually
		if currentDisplays.map(\.localizedName) == NSScreen.screens.map(\.localizedName) {
			return
		}

		if minWidthToShowDock == 0.0 {
			print("Dock not updated")
		} else if NSScreen.screens.filter({ $0.frame.width >= minWidthToShowDock }).count >= 1 {
			toggleDockVisibility(hidden: false)
		} else {
			toggleDockVisibility(hidden: true)
		}

		self.currentDisplays = NSScreen.screens.map { screen in
			return DisplayInfo(localizedName: screen.localizedName, frame: screen.frame)
		}
	}
}

struct DisplayInfo: Hashable {
	var localizedName: String
	var frame: CGRect
}
										
