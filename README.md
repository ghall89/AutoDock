# AutoDock

![GitHub](https://img.shields.io/github/license/ghall89/AutoDock) ![GitHub release (with filter)](https://img.shields.io/github/v/release/ghall89/AutoDock)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/T6T66ELM7)

A MacOS menubar utility for automatically hiding/showing the dock based on the size of your connected display(s).

## Installation

### Requirements

- An Intel or Apple Silicon Mac running macOS 15 Sequoia or later

_Note: It is entirely possible the app can be compiled to run on older versions of MacOS, I'm just unable to test. Feel free to try compiling for older systems and submit a pull request with any changes._

### Download

You can [manually download](https://github.com/ghall89/AutoDock/releases) the latest release of AutoDock.

If you prefer to use homebrew...

- Add the 'ghall89/tap' tap with `brew tap ghall89/tap`
- Install AutoDock with `brew install --cask autodock`

### First Launch

When launching AutoDock for the first time, you will be asked by macOS to grant automation permissions. This is required for setting the Dock's visibility, and AutoDock will not function without it.

## Compile From Source

### Prerequisites

- MacOS 15+
- [task](https://taskfile.dev/)
- [mint](https://github.com/yonaskolb/Mint)
- [swift-bundler](https://swiftbundler.dev/documentation/swift-bundler)
- [create-dmg](https://github.com/create-dmg/create-dmg) (optional - only required if you want to create a DMG)

### Instructions

1. Clone this repo with `git clone git@github.com:ghall89/AutoDock.git`
2. Navigate to the project directory in your terminal
3. Run `task build`, this will output to `.build/bundler/AutoDock.app`

## Troubleshooting

Before submitting an issue, please check if your issue is described here.

### AutoDock doesn't show/hide the Dock as expected

It's likely AutoDock doesn't have permission to update the Dock's settings. Go to System Settings, navigate to Privacy & Security > Automation > AutoDock, and ensure the toggle for System Events is turned on, then quit and re-open AutoDock.

## Dependencies

- [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin-Modern)
