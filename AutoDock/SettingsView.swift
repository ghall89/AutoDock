import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
	@AppStorage("minWidthToShowDock") private var minWidthToShowDock = 0.0
	@EnvironmentObject var displayManager: DisplayManager
	
	var body: some View {
		Form {
			Picker(selection: $minWidthToShowDock) {
				ForEach(displayManager.currentDisplays, id: \.self) { display in
					let displayName = display.localizedName
					
					Text("\(createLabel(display.frame.width)) - \(displayName)").tag(Double(display.frame.width))
				}
				if displayManager.currentDisplays.count(where: { $0.frame.width == minWidthToShowDock }) == 0 {
					Divider()
					Text(createLabel(minWidthToShowDock)).tag(minWidthToShowDock)
				}
				Divider()
				Text("None").tag(0.0)
			} label: {
				Text("Dock Display Threshold")
			}
			LaunchAtLogin.Toggle()
		}
		.formStyle(.grouped)
		.frame(width: 400, height: 120)
	}
	
	private func createLabel(_ value: Double) -> String {
		return "\(value)pts"
	}
}
