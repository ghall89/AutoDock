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
						Text("\(createLabel(display.frame))").tag(display.frame)
					}
					if
						displayManager.connectedDisplays.count(where: { $0.frame.width == minResolutionToShowDock.width }) == 0
						&& minResolutionToShowDock != .zero
					{
						Divider()
						Text(createLabel(minResolutionToShowDock)).tag(minResolutionToShowDock)
					}
					Divider()
					Text("None (Disables AutoDock)").tag(CGRect.zero)
				} label: {
					Text("Minimum screen resolution")
				}
			}
			Section {
				LaunchAtLogin.Toggle()

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
