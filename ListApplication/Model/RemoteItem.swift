import Foundation

struct RemoteItem: Identifiable {
    let text: String
    let confidence: CGFloat
    let image: String
    let id: String
}

extension RemoteItem: Codable {
    enum CodingKeys: String, CodingKey {
        case text, confidence, image
        case id = "_id"
    }
}
