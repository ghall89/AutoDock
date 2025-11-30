import AppKit
import Combine
import SwiftUI

class DisplayManager: ObservableObject {
    @AppStorage("minResolutionToShowDock") var minResolutionToShowDock: CGRect = .zero
    @AppStorage("onlyOnPrimaryDisplay") var onlyOnPrimaryDisplay = true
    @AppStorage("alsoToggleMenubar") var alsoToggleMenubar = false

    @Published var connectedDisplays: [DisplayInfo] = []
    @Published var systemEventsPermitted: Bool = true

    init() {
        setupDisplayChangeListener()
        detectDisplay()
    }

    private var cancellables = Set<AnyCancellable>()

    private func setupDisplayChangeListener() {
        NotificationCenter.default
            .publisher(for: NSApplication.didChangeScreenParametersNotification)
            .receive(on: RunLoop.main)
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                print("Display configuration changed (debounced).")
                self?.detectDisplay()
            }
            .store(in: &cancellables)
    }

    private func detectDisplay() {
        guard !NSScreen.screens.isEmpty else {
            print("No displays are connected.")
            connectedDisplays = []
            return
        }

        // check if display parameters actually changed...
        // this is to prevent the app from overriding the user
        // if the Dock's autohide is toggled manually
        print(connectedDisplays.map(\.localizedName))
        print(NSScreen.screens.map(\.localizedName))
        if connectedDisplays.map(\.localizedName) == NSScreen.screens.map(\.localizedName) {
            return
        }

        if minResolutionToShowDock == .zero {
            print("Dock not updated")
        } else if NSScreen.screens.filter({ $0.frame.width >= minResolutionToShowDock.width }).count
            >= 1
        {
            handleVisibility(hidden: false)
        } else {
            handleVisibility(hidden: true)
        }

        connectedDisplays = NSScreen.screens.map { screen in
            let displayToAdd = DisplayInfo(
                id: screen.description,
                localizedName: screen.localizedName,
                frame: screen.frame,
                primaryDisplay: isPrimaryDisplay(screen)
            )

            return displayToAdd
        }
    }

    private func isPrimaryDisplay(_ screen: NSScreen) -> Bool {
        return screen.frame.origin == CGPoint(x: 0, y: 0)
    }

    private func handleVisibility(hidden: Bool) {
        toggleVisibility(hidden: hidden, preference: .autohide)
        if alsoToggleMenubar {
            toggleVisibility(hidden: hidden, preference: .autohideMenuBar)
        }
    }

    private func toggleVisibility(hidden: Bool, preference: DockPreference) {
        // don't bother updating dock autohide setting if it matches the new value
        let currentAutoHidePref = getCurrentPreference(preference)

        if currentAutoHidePref == nil {
            return
        }

        if currentAutoHidePref != hidden {
            let script = """
                tell application "System Events"
                	set \(preference.rawValue) of dock preferences to \(hidden.description)
                end tell
                """

            do {
                _ = try runAppleScript(script: script)
            } catch {
                print(error)
            }
        }
    }

    private func getCurrentPreference(_ preference: DockPreference) -> Bool? {
        let script = """
            tell application "System Events"
            	get \(preference.rawValue) of dock preferences
            end tell
            """

        do {
            if let boolString = try runAppleScript(script: script) {
                return boolString == "true"
            }
        } catch {
            systemEventsPermitted = false
        }

        return nil
    }

    private enum DockPreference: String {
        case autohide = "autohide"
        case autohideMenuBar = "autohide menu bar"
    }
}
