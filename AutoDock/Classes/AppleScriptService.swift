import AppleScriptObjC
import Foundation

class AppleScriptService {
	private func runAppleScript(script: String) throws -> String? {
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
	
	func setDockPreferencesValue(preference: Preference, value: Bool, condition: Bool = true) throws {
		if condition {
			let script = """
			tell application "System Events"
				set \(preference.rawValue) of dock preferences to \(value)
			end tell
			"""
			
			do {
				_ = try runAppleScript(script: script)
			} catch {
				logger.error("ERROR: \(error)")
				throw error
			}
		}
	}
	
	func getDockPreferencesValue(preference: Preference) throws -> Bool? {
		let script = """
		tell application "System Events"
			get \(preference.rawValue) of dock preferences
		end tell
		"""
		
		do {
			if let boolString = try runAppleScript(script: script) {
				return boolString == "true"
			}
		} catch {
			logger.error("ERROR: \(error)")
			throw error
		}
		
		return nil
	}
	
	enum Preference: String {
		case autohideDock = "autohide"
		case autohideMenubar = "autohide menu bar"
	}
	
	enum AppleScriptError: Error {
		case scriptCompilationFailed
		case executionFailed(String)
	}
}
