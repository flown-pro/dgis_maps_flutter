import Foundation
import DGis

protocol ISettingsService: AnyObject {
	var onCurrentLanguageDidChange: (() -> Void)? { get set }
	var mapDataSource: MapDataSource { get set }
	var httpCacheEnabled: Bool { get set }
	var logLevel: DGis.LogLevel { get set }
}

final class SettingsService: ISettingsService {
	private enum Keys {
		static let mapDataSource = "Global/MapDataSource"
		static let httpCacheEnabled = "Global/HttpCacheEnabled"
		static let logLevel = "Global/LogLevel"
	}

	var onCurrentLanguageDidChange: (() -> Void)?

	var mapDataSource: MapDataSource {
		get {
			let rawValue: String? = self.storage.value(forKey: Keys.mapDataSource)
			return rawValue.flatMap { MapDataSource(rawValue: $0) } ?? .default
		}
		set {
			self.storage.set(newValue.rawValue, forKey: Keys.mapDataSource)
		}
	}

	var httpCacheEnabled: Bool {
		get {
			return self.storage.value(forKey: Keys.httpCacheEnabled) ?? false
		}
		set {
			self.storage.set(newValue, forKey: Keys.httpCacheEnabled)
		}
	}

	var logLevel: DGis.LogLevel {
		get {
			let rawValue: UInt32? = self.storage.value(forKey: Keys.logLevel)
			return rawValue.flatMap { DGis.LogLevel(rawValue: $0) } ?? .warning
		}
		set {
			self.storage.set(newValue.rawValue, forKey: Keys.logLevel)
		}
	}

	private let storage: IKeyValueStorage

	init(
		storage: IKeyValueStorage
	) {
		self.storage = storage
	}
}
