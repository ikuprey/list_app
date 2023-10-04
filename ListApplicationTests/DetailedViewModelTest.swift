import XCTest
@testable import ListApplication

final class DetailedViewModelTest: XCTestCase {

    private let item = RemoteItem(text: "test",
                                  confidence: 0.5,
                                  image: "test",
                                  id: "test")

    func testProperties() {
        let model = DetailedViewModel(item: item)
        XCTAssert(model.title == item.text, "Title")
        XCTAssert(model.id == item.text, "Id")
        XCTAssert(model.confidence == String(format: "%.2f", item.confidence), "Confidence")
    }
}
