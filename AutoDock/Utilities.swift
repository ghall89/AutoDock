import Foundation

func toggleDockVisibility(hidden: Bool) {
	// don't bother updating dock autohide setting if it matches the new value
	if let currentPref = getDockAutohidePref() {
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

func getDockAutohidePref() -> Bool? {
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
			
			return dockIsCurrentlyHidden
		}
	} catch {
		print("Failed to read Dock settings: \(error)")
	}
	
	return nil
}
