import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
	@AppStorage("minWidthToShowDock") private var minWidthToShowDock = 0.0
	@AppStorage("autoUpdate") private var autoUpdate = true
	@EnvironmentObject var displayManager: DisplayManager

	var body: some View {
		Form {
			Section {
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
					Text("Show Dock on displays wider than...")
				}

				LaunchAtLogin.Toggle()
			}
			Section {
				VStack(alignment: .leading) {
					HStack {
						Text("Permission to automate system events")
						Spacer()
						Image(systemName: "circle.fill")
							.foregroundStyle(displayManager.systemEventsPermitted ? Color.green : Color.red)
					}
					Text("AutoDock requires permission to automate system events in order to change the settings for your Dock.")
						.font(.footnote)
				}
				if !displayManager.systemEventsPermitted {
					Button("Check System Privacy Settings", action: openPrivacySecuritySettings)
				}
			}
		}
		.formStyle(.grouped)
		.frame(width: 400, height: 190)
	}

	private func createLabel(_ value: Double) -> String {
		return "\(Int(value))pts"
	}
}
