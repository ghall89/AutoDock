import ScriptingBridge

final class SystemEventsManager {
	let systemEvents: SystemEventsApplication

	init?() {
		guard let systemEvents = SBApplication(bundleIdentifier: "com.apple.systemevents") as? SystemEventsApplication
		else {
			print("Failed to access System Events")
			return nil
		}

		self.systemEvents = systemEvents
	}
}
