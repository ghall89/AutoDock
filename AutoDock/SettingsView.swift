import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
	@AppStorage("minWidthToShowDock") private var minWidthToShowDock = 2000.0
	
	let predefinedSizes = [
		1000.0,
		2000.0,
		3000.0
	]
	
	var body: some View {
		Form {
			Picker(selection: $minWidthToShowDock) {
				ForEach(predefinedSizes, id: \.self) { value in
					Text(createLabel(value)).tag(value)
				}
				if !predefinedSizes.contains(minWidthToShowDock) {
					Divider()
					Text(createLabel(minWidthToShowDock)).tag(minWidthToShowDock)
				}
			} label: {
				Text("Minimum Display Size to Show Dock")
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
