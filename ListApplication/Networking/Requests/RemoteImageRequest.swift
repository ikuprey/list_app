import Foundation

class RemoteImageRequest {
    private let image: String

    init(image: String) {
        self.image = image
    }
}

extension RemoteImageRequest: ApiResource {
    typealias ModelType = Data

    var request: URLRequest {
        let url = URL(string: image)!
        return URLRequest(url: url)
    }

    var encoded: Bool {
        return false
    }
}



