import Foundation

class RemoteItemsRequest {
    private let maxId: String?
    private let sinceId: String?

    init(maxId: String? = nil, sinceId: String? = nil) {
        self.maxId = maxId
        self.sinceId = sinceId
    }
}

extension RemoteItemsRequest: ApiResource {
    typealias ModelType = [RemoteItem]

    var request: URLRequest {
        var queries: [URLQueryItem] = []
        if let maxId {
            queries.append(URLQueryItem(name: "max_id", value: maxId))
        }

        if let sinceId {
            queries.append(URLQueryItem(name: "since_id", value: sinceId))
        }

        var value = URLRequest(url: url.appending(queryItems: queries))
        value.setValue("f718636aeca5dc686b6678b1b31b619f", forHTTPHeaderField: "Authorization")
        return value
    }
}
