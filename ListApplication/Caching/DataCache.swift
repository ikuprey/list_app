import Foundation

public protocol DataCacheType: AnyObject {
    func data(for url: URL) -> Data?
    func insertData(_ data: Data?, for url: URL)
    func removeData(for url: URL)
    func removeAllData()
}

public struct CacheConfig {
    public let countLimit: Int
    public let memoryLimit: Int

    public static let defaultConfig = CacheConfig(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
}

public final class DataCache: DataCacheType {
    private lazy var dataCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()

    private let lock = NSLock()
    private let config: CacheConfig

    public init(config: CacheConfig = .defaultConfig ) {
        self.config = config
    }

    public func data(for url: URL) -> Data? {
        lock.lock(); defer { lock.unlock() }
        // search for data
        if let data = dataCache.object(forKey: url as AnyObject) as? NSData {
            return Data(referencing: data)
        }
        return nil
    }

    public func insertData(_ data: Data?, for url: URL) {
        guard let data else { return removeData(for: url) }
        lock.lock(); defer { lock.unlock() }
        dataCache.setObject(NSData(data: data),
                            forKey: url as AnyObject,
                            cost: 1)
    }

    public func removeData(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        dataCache.removeObject(forKey: url as AnyObject)
    }

    public func removeAllData() {
        lock.lock(); defer { lock.unlock() }
        dataCache.removeAllObjects()
    }
}
