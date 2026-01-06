import Foundation

struct DisplayHistoryItem: Codable, Identifiable {
	var id: UUID
	var displayInfo: DisplayInfo
	var lastConnected: Date

	init(displayInfo: DisplayInfo, lastConnected: Date) {
		id = UUID()
		self.displayInfo = displayInfo
		self.lastConnected = lastConnected
	}
}

struct DisplayInfo: Hashable, Codable {
	var id: String
	var localizedName: String
	var frame: CGRect
	var primaryDisplay: Bool
}
