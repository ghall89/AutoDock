import ScriptingBridge

extension SystemEventsManager {
	enum DockPreferenceKey: String {
		case autohide
		case autohideMenuBar
	}

	func getDockPreference(_ key: DockPreferenceKey) -> Bool {
		guard let dock = systemEvents.dockPreferences as? SBObject else {
			return false
		}
		guard let value = dock.value(forKey: key.rawValue) as? Bool else {
			return false
		}

		return value
	}

	func setDockPreference(_ key: DockPreferenceKey, to value: Bool) {
		guard let dock = systemEvents.dockPreferences as? SBObject else {
			return
		}

		let currentValue = getDockPreference(key)

		if currentValue == value {
			return
		}

		dock.setValue(NSNumber(value: value), forKey: key.rawValue)
	}
}
