import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
	@AppStorage("minWidthToShowDock") private var minWidthToShowDock = 0.0
	@EnvironmentObject var displayManager: DisplayManager
	
	var body: some View {
		Form {
			Picker(selection: $minWidthToShowDock) {
				ForEach(displayManager.connectedDisplays, id: \.self) { display in
					let displayName = display.localizedName
					
					Text("\(createLabel(display.frame.width)) - \(displayName)").tag(Double(display.frame.width))
				}
				if
					displayManager.connectedDisplays.count(where: { $0.frame.width == minWidthToShowDock }) == 0
						&& minWidthToShowDock != 0.0
				{
					Divider()
					Text(createLabel(minWidthToShowDock)).tag(minWidthToShowDock)
				}
				Divider()
				Text("None").tag(0.0)
			} label: {
				Text("Minimum Width to Show Dock")
			}
			LaunchAtLogin.Toggle()
		}
		.formStyle(.grouped)
		.frame(width: 400, height: 120)
	}
	
	private func createLabel(_ value: Double) -> String {
		return "\(Int(value))pts"
	}
}
