import AppleScriptObjC
import Foundation

enum AppleScriptError: Error {
	case scriptCompilationFailed
	case executionFailed(String)
}

func runAppleScript(script: String) throws -> String? {
	var result: String?
	var error: NSDictionary?

	guard let appleScript = NSAppleScript(source: script) else {
		throw AppleScriptError.scriptCompilationFailed
	}

	result = appleScript.executeAndReturnError(&error).stringValue
	if let error = error {
		throw AppleScriptError.executionFailed(error.description)
	}

	return result
}
