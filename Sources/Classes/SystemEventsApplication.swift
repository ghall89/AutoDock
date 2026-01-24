import Foundation
import ScriptingBridge

@objc
protocol SystemEventsApplication {
	@objc
	optional var dockPreferences: SystemEventsDockPreferencesObject { get }
	@objc
	optional func activate()
}

extension SBApplication: SystemEventsApplication {}

@objc
protocol SystemEventsDockPreferencesObject {
	@objc
	optional var autohide: Bool { get set }
	@objc
	optional var dockSize: Double { get set }
	@objc
	optional var autohideMenuBar: Bool { get set }
}

extension SBObject: SystemEventsDockPreferencesObject {}

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

		dock.setValue(NSNumber(value: value), forKey: key.rawValue)
	}
}
