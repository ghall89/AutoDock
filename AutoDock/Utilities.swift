import AppleScriptObjC
import Foundation

func toggleDockVisibility(hidden: Bool) {
	// don't bother updating dock autohide setting if it matches the new value
	if getDockAutohidePref() != hidden {
		let script = """
			tell application "System Events"
				set autohide of dock preferences to \(hidden.description)
			end tell
			"""
		
		if let appleScript = NSAppleScript(source: script) {
			var error: NSDictionary?
			
			appleScript.executeAndReturnError(&error)
			if let error = error {
				print(error)
			}
		} else {
			print("Failed to create AppleScript.")
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
