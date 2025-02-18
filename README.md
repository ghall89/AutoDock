# AutoDock

![GitHub](https://img.shields.io/github/license/ghall89/AutoDock) ![GitHub release (with filter)](https://img.shields.io/github/v/release/ghall89/AutoDock)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/T6T66ELM7)

A MacOS menubar utility for automatically hiding/showing the dock based on the size of your connected display(s).

## Installation

### Requirements

- An Intel or Apple Silicon Mac running MacOS 15 Sequoia or later

_Note: It is entirely possible the app can be compiled to run on older versions of MacOS, I'm just unable to test. Feel free to try compiling for older systems and submit a pull request with any changes._

### Download

You can [manually download](https://github.com/ghall89/AutoDock/releases) the latest release of AutoDock.

If you prefer to use homebrew...

- Add the 'ghall89/tap' tap with `brew tap ghall89/tap`
- Install AutoDock with `brew install --cask autodock`

## Compile From Source

### Prerequisites

- MacOS 15+
- The Latest Version of Xcode
- An [Apple Developer Account](https://developer.apple.com)

### Instructions

1. Clone this repo with `git clone git@github.com:ghall89/AutoDock.git`
2. Open `AutoDock.xcodeproj` from the project directory
3. Wait for package dependencies to download
4. From the menubar, go to `Product → Archive`
5. When archive is complete, click `Distribute App` and select `Direct Distribution`, `Debug`, or `Custom` and follow the prompts

## Dependencies

- [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin-Modern)
- [Sparkle](https://github.com/sparkle-project/Sparkle)
