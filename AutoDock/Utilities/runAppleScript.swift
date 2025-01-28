import AppleScriptObjC
import Foundation

func runAppleScript(script: String) -> String? {
	var result: String?
	
	if let appleScript = NSAppleScript(source: script) {
		var error: NSDictionary?
		
		result = appleScript.executeAndReturnError(&error).stringValue
		if let error = error {
			print(error)
		}
		
	} else {
		print("Failed to create AppleScript.")
	}
	
	print(result ?? "")
	return result
}
