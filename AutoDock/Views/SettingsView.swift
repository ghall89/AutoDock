import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
	@AppStorage("minResolutionToShowDock") private var minResolutionToShowDock: CGRect = .zero
	@AppStorage("autoUpdate") private var autoUpdate = true
	@EnvironmentObject var displayManager: DisplayManager

	var body: some View {
		Form {
			Section {
				Picker(selection: $minResolutionToShowDock) {
					ForEach(displayManager.connectedDisplays, id: \.self) { display in
						let displayName = display.localizedName

						Text("\(createLabel(display.frame)) - \(displayName)").tag(display.frame)
					}
					if
						displayManager.connectedDisplays.count(where: { $0.frame.width == minResolutionToShowDock.width }) == 0
							&& minResolutionToShowDock != .zero
					{
						Divider()
						Text(createLabel(minResolutionToShowDock)).tag(minResolutionToShowDock)
					}
					Divider()
					Text("None").tag(0.0)
				} label: {
					Text("Hide dock at display resolutions lower than...")
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
		.frame(width: 400, height: 200)
	}

	private func createLabel(_ value: CGRect) -> String {
		return "\(Int(value.width))x\(Int(value.height))"
	}
}
