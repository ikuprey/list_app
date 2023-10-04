import Foundation
import UIKit

protocol DataProviderProtocol {
    // RemoteItem could be replaced with some associatedtype 
    func items(maxId: String?, sinceId: String?) async throws -> [RemoteItem]
    func image(for item: RemoteItem) async throws -> Data
}

class DataProvider: DataProviderProtocol {
    private let cache = DataCache()

    func items(maxId: String? = nil, sinceId: String? = nil) async throws -> [RemoteItem] {
        let resource = RemoteItemsRequest(maxId: maxId, sinceId: sinceId)
        let request = ApiRequest(resource: resource, cache: cache)
        let result = try await request.execute()
        return result
    }

    func image(for item: RemoteItem) async throws -> Data {
        let resource = RemoteImageRequest(image: item.image)
        let request = ApiRequest(resource: resource, cache: cache)
        let result = try await request.execute()
        return result
    }
}

