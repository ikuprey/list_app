import Foundation

protocol ApiResource {
    associatedtype ModelType: Codable
    var request: URLRequest { get }
    var encoded: Bool { get }
}

extension ApiResource {
    /// As a basic rule - in most cases responce needs to be decoded
    var encoded: Bool {
        return true
    }

    /// As a basic url for this specific case
    var url: URL {
        URL(string: "https://marlove.net/e/mock/v1/items")!
    }
}

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data, encoded: Bool, cached: Bool) throws -> ModelType
    func execute() async throws -> ModelType
}

extension NetworkRequest {
    func load(_ request: URLRequest, encoded: Bool = true) async throws -> ModelType {
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decode(data, encoded: encoded, cached: false)
    }
}

final class ApiRequest<Resource: ApiResource, Cache: DataCacheType>{
    let resource: Resource
    let cache: Cache?

    init(resource: Resource, cache: Cache? = nil) {
        self.resource = resource
        self.cache = cache
    }
}

extension ApiRequest: NetworkRequest {
    func decode(_ data: Data, encoded: Bool, cached: Bool = false) throws -> Resource.ModelType {
        if !cached, let cache, let url = resource.request.url {
            cache.insertData(data, for: url)
        }

        if !encoded, let value = data as? ModelType {
            return value
        }

        let result = try JSONDecoder().decode(ModelType.self, from: data)
        return result
    }

    func execute() async throws -> Resource.ModelType {
        if let cache,
           let url = resource.request.url,
           let result = cache.data(for: url) {
            return try decode(result, encoded: resource.encoded, cached: true)
        }
        return try await load(resource.request, encoded: resource.encoded)
    }
}


