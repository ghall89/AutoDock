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
