import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
	@AppStorage("minResolutionToShowDock") private var minResolutionToShowDock: CGRect = .zero
	@AppStorage("alsoToggleMenubar") private var alsoToggleMenubar: Bool = false
	@AppStorage("autoUpdate") private var autoUpdate = true
	@EnvironmentObject var displayManager: DisplayManager
	
	@State private var showSettingsHint: Bool = false

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
				Toggle("Also toggle Menu Bar", isOn: $alsoToggleMenubar)
				if showSettingsHint {
					Text("Restart AutoDock or connect/disconnect a display to apply settings.")
						.font(.footnote)
						.transition(.slide)
				}
			}
			.onChange(of: minResolutionToShowDock, showHint)
			.onChange(of: alsoToggleMenubar, showHint)
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
		.frame(width: 400, height: showSettingsHint ? 280 : 240)
		.animation(.easeInOut, value: showSettingsHint)
	}

	private func createLabel(_ value: CGRect) -> String {
		return "\(Int(value.width))x\(Int(value.height))"
	}
	
	private func showHint() {
		withAnimation {
			showSettingsHint = true
		}
	}
}
