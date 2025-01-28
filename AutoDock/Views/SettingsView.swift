import LaunchAtLogin
import SwiftUI

struct SettingsView: View {

	@EnvironmentObject var displayManager: DisplayManager

	var body: some View {
		Form {
			Section {
				Picker(selection: $displayManager.minWidthToShowDock) {
					ForEach(displayManager.connectedDisplays, id: \.self) { display in
						let displayName = display.localizedName
						
						Text("\(getResolutionString(display.frame.size)) - \(displayName)").tag(Double(display.frame.width))
					}
					if !displayManager.displayHistory.isEmpty {
						Divider()
						ForEach(displayManager.displayHistory) { display in
							let displayInfo = display.displayInfo
							let displayName = displayInfo.localizedName
							if !displayManager.connectedDisplays.contains(where: { isSameDisplay(displayOne: $0, displayTwo: displayInfo) }) {
								Text("\(getResolutionString(displayInfo.frame.size)) - \(displayName)").tag(Double(displayInfo.frame.width))
							}
						}
					}
					Divider()
					Text("None").tag(0.0)
				} label: {
					Text("Minimum Resolution")
				}
				.help("The minimum display resolution for the dock to be visible.")
				Toggle("Only Apply to Primary Display", isOn: $displayManager.onlyOnPrimaryDisplay)
					.help("Only show/hide dock on your primary display (the display where your dock is located).")
			}
			Section {
				LaunchAtLogin.Toggle()
					.help("Automatically launch 'AutoDock' at startup.")
			}
		}
		.formStyle(.grouped)
		.frame(width: 400, height: 170)
	}

	private func getResolutionString(_ size: CGSize) -> String {
		return "\(size.width.description.replacingOccurrences(of: ".0", with: "")) x \(size.height.description.replacingOccurrences(of: ".0", with: ""))"
	}
}
