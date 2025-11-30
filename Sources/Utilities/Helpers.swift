import AppKit

func openPrivacySecuritySettings() {
    if let url = URL(
        string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation")
    {
        NSWorkspace.shared.open(url)
    }
}

func isSameDisplay(displayOne: DisplayInfo, displayTwo: DisplayInfo) -> Bool {
    return displayOne.localizedName == displayTwo.localizedName
        && displayOne.frame.width == displayTwo.frame.width
        && displayOne.frame.height == displayTwo.frame.height
}
