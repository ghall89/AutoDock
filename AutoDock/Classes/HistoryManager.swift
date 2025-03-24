import Foundation

class HistoryManager: ObservableObject {
	
	
	func storeHistoryAsJSON(history: [DisplayHistoryItem]) {
		let encoder = JSONEncoder()
		do {
			let jsonData = try encoder.encode(history)
			let jsonFile = try getHisoryPath()
			
			try jsonData.write(to: jsonFile, options: .atomic)
		} catch {
			logger.error("ERROR: \(error)")
		}
	}
	
	
	func loadHistoryFromJSON() throws -> [DisplayHistoryItem] {
		var history = [DisplayHistoryItem]()
		
		do {
			let fileURL = try getHisoryPath()
			
			let jsonData = try Data(contentsOf: fileURL)
			history = decodeJSON(json: jsonData, model: DisplayHistoryItem.self)
			
			return history
		} catch {
			logger.error("ERROR: \(error)")
			throw error
		}
	}
	
	public func decodeJSON<T: Decodable>(json: Data, model _: T.Type) -> [T] {
		let decoder = JSONDecoder()
		do {
			let games = try decoder.decode([T].self, from: json)
			return games
		} catch let error as NSError {
			logger.error("Error decoding JSON: \(error.localizedDescription)")
		} catch {
			logger.error("ERROR: \(error)")
		}
		return []
	}
	
	func getHisoryPath() throws -> URL {
		let fileManager = FileManager.default
		
		do {
			let applicationSupport = try fileManager.url(
				for: .applicationSupportDirectory,
				in: .userDomainMask,
				appropriateFor: .applicationSupportDirectory,
				create: true
			)
			
			let bundleId = Bundle.main.bundleIdentifier!
			
			let applicationSubdirectory = applicationSupport.appendingPathComponent(bundleId, conformingTo: .folder)
			try fileManager.createDirectory(at: applicationSubdirectory, withIntermediateDirectories: true)
			
			let jsonFile = applicationSubdirectory.appendingPathComponent("history.json", conformingTo: .json)
			
			return jsonFile
		} catch {
			logger.error("ERROR: \(error)")
			throw error
		}
	}
}
