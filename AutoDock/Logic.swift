import AppKit
import Foundation
import CoreGraphics

func detectDisplay() -> [CGRect] {
	var displays = [CGRect]()
	guard !NSScreen.screens.isEmpty else {
		print("S3", "No displays are connected.")
		return displays
	}
	
	NSScreen.screens.forEach {
		print($0.frame)
		displays.append($0.frame)
	}
	
	if displays.filter({ $0.width > 2000 }).count >= 1 {
		toggleDockVisibility(hidden: false)
	} else {
		toggleDockVisibility(hidden: true)
	}
	
	return displays
}

func toggleDockVisibility(hidden: Bool) {
	let task = Process()
	task.launchPath = "/usr/bin/defaults"
	task.arguments = ["write", "com.apple.dock", "autohide", "-bool \(hidden.description)"]
	
	let killDockTask = Process()
	killDockTask.launchPath = "/usr/bin/killall"
	killDockTask.arguments = ["Dock"]
	
	do {
		try task.run()
		task.waitUntilExit()
		
		try killDockTask.run()
		killDockTask.waitUntilExit()
		
		print(hidden ? "Dock is now hidden." : "Dock is now visible.")
	} catch {
		print("Failed to update Dock settings: \(error)")
	}
}
