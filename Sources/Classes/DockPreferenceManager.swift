import ScriptingBridge

final class DockPreferencesManager {
	enum DockPreferenceKey: String {
		case autohide
		case autohideMenuBar
	}

	private let systemEvents: SystemEventsApplication

	init?() {
		guard let systemEvents = SBApplication(bundleIdentifier: "com.apple.systemevents") as? SystemEventsApplication
		else {
			print("Failed to access System Events")
			return nil
		}

		self.systemEvents = systemEvents
	}

	func getPreference(_ key: DockPreferenceKey) -> Bool {
		guard let dock = systemEvents.dockPreferences as? SBObject else {
			return false
		}
		guard let value = dock.value(forKey: key.rawValue) as? Bool else {
			return false
		}

		return value
	}

	func setPreference(_ key: DockPreferenceKey, to value: Bool) {
		guard let dock = systemEvents.dockPreferences as? SBObject else {
			return
		}

		let currentValue = getPreference(key)

		if currentValue == value {
			return
		}

		dock.setValue(NSNumber(value: value), forKey: key.rawValue)
	}
}
