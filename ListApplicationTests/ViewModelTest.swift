import XCTest
@testable import ListApplication

final class ViewModelTest: XCTestCase {

    private var mock: DataProviderMock!
    private let item = RemoteItem(text: "test",
                                  confidence: 0.5,
                                  image: "test",
                                  id: "test")

    override func setUpWithError() throws {
        mock = DataProviderMock()
    }

    override func tearDownWithError() throws {
        mock = nil
    }

    func testImage_Success() async {
        mock.image = .init()
        let model = ViewModel(with: mock)
        let image = try? await model.image(for: item )
        XCTAssertNotNil(image, "Image data is not empty")
    }

    func testImage_Fail() async {
        let model = ViewModel(with: mock)
        let image = try? await model.image(for: item)
        XCTAssertNil(image, "Image data is empty")
    }

    func testLoad_Success() async {
        mock.items = [item]
        let model = ViewModel(with: mock)

        let expectation = XCTestExpectation(description: "fetched some items")
        model.load { updated in
            XCTAssert(updated, "Items has been updated")
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)
    }

    func testLoad_Fail() async {
        let model = ViewModel(with: mock)

        let expectation = XCTestExpectation(description: "Failed to fetched some items")
        expectation.isInverted = true
        model.load { _ in
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)
    }

    func testRefresh_Success() async {
        mock.items = [item]
        let model = ViewModel(with: mock)

        let expectation = XCTestExpectation(description: "fetched some items")
        model.refresh {
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)
    }

    func testRefresh_Fail() async {
        let model = ViewModel(with: mock)

        let expectation = XCTestExpectation(description: "Failed to fetched some items")
        expectation.isInverted = true
        model.load { _ in
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)
    }
}


struct DataProviderMock: DataProviderProtocol {

    var items: [RemoteItem] = []
    var image: Data?

    func items(maxId: String?, sinceId: String?) async throws -> [RemoteItem] {
        guard items.count > 0 else {
            print("List is epmpty")
            throw NSError(domain: "Empty list", code: 0)
        }

        return items
    }

    func image(for item: RemoteItem) async throws -> Data {
        guard let data = image else {
            print("Data is epmpty")
            throw NSError(domain: "Empty data", code: 0)
        }

        return data
    }
}
