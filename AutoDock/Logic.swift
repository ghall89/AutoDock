import Foundation

func toggleDockVisibility(hidden: Bool) {
	let task = Process()
	task.launchPath = "/usr/bin/defaults"
	task.arguments = ["write", "com.apple.dock", "autohide", "-bool", hidden.description]
	
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
