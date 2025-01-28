import Foundation

func toggleDockVisibility(hidden: Bool) {
	// don't bother updating dock autohide setting if it matches the new value
	let currentAutoHidePref = getDockAutohidePref()
	
	if (currentAutoHidePref == nil) {
		return
	}
	
	if currentAutoHidePref != hidden {
		let script = """
			tell application "System Events"
				set autohide of dock preferences to \(hidden.description)
			end tell
			"""

		_ = runAppleScript(script: script)
	}
}

private func getDockAutohidePref() -> Bool? {
	let script = """
		tell application "System Events"
			get autohide of dock preferences
		end tell
		"""

	if let boolString = runAppleScript(script: script) {
		return boolString == "true"
	}
	
	return nil
}
