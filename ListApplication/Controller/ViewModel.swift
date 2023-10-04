import Foundation

protocol ViewModelProtocol: AnyObject {
    var items: [RemoteItem] { get }
    var message: String { get }
    
    func load(since item: RemoteItem?, completion: @escaping (Bool) -> Void)
    func refresh(completion: @escaping () -> Void)
    func image(for item: RemoteItem) async throws -> Data
}

class ViewModel<Provider: DataProviderProtocol>: ViewModelProtocol {

    // Could be replaced with abstraction and injected
    private let provider: Provider

    init(with provider: Provider) {
        self.provider = provider
    }

    var items: [RemoteItem] = []

    var message: String = "No results\nPull to prefresh"

    func load(since item: RemoteItem? = nil, completion: @escaping (Bool) -> Void) {
        Task {
            let result = try await provider.items(maxId: item?.id, sinceId: nil)
            self.items.append(contentsOf: result)
            DispatchQueue.main.async {
                completion(result.count > 0)
            }
        }
    }

    func refresh(completion: @escaping () -> Void) {
        Task {
            let result = try await provider.items(maxId: nil, sinceId: nil)
            self.items = result
            DispatchQueue.main.async {
                completion()
            } 
        }
    }

    func image(for item: RemoteItem) async throws -> Data {
        return try await self.provider.image(for: item)
    }
}
