import Foundation

protocol DetailedViewModelProtocol: AnyObject {
    var title: String { get }
    var id: String { get }
    var confidence: String { get }
}


class DetailedViewModel: DetailedViewModelProtocol {
    private let item: RemoteItem

    init(item: RemoteItem) {
        self.item = item
    }

    var title: String {
        return item.text
    }

    var id: String {
        return item.id
    }

    var confidence: String {
        return String(format: "%.2f", item.confidence)
    }
}
