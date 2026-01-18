import Foundation

struct DisplayInfo: Hashable, Codable {
	var id: String
	var localizedName: String
	var frame: CGRect
	var primaryDisplay: Bool
}
