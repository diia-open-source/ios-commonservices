import XCTest
import DiiaCommonTypes
@testable import DiiaCommonServices

class BaseSearchPresenterTests: XCTestCase {
    
    var view: BaseSearchMockView!
    
    override func tearDown() {
        view = nil
        super.tearDown()
    }
    
    func test_presenter_numberOfItems_worksCorrect() {
        // Arrange
        let sut = createSut()
        let expectedValue = 2
        
        // Act
        sut.configureView()
        let actualValue = sut.numberOfItems()
        
        // Assert
        XCTAssertEqual(actualValue, expectedValue)
        XCTAssertTrue(view.isViewUpdateCalled)
    }
    
    func test_presenter_itemAtIndex_worksCorrect() {
        // Arrange
        let sut = createSut()
        let expectedNameValue = "test1"
        
        // Act
        sut.configureView()
        let actualValue = sut.itemAt(index: .zero)
        
        // Assert
        XCTAssertEqual(actualValue, expectedNameValue)
    }
    
    func test_presenter_itemSelected_worksCorrect() {
        // Arrange
        let sut = createSut()
        
        // Act
        sut.configureView()
        sut.selectItem(index: .zero)
        
        // Assert
        XCTAssertTrue(view.isCloseModuleCalled)
    }
    
    func test_presenter_setSearch_worksCorrect() {
        // Arrange
        let sut = createSut()
        let expectedValue = 1
        
        // Act
        sut.configureView()
        sut.setSearchText(text: "test1")
        let actualValue = sut.numberOfItems()
        
        // Assert
        XCTAssertTrue(view.isViewUpdateCalled)
        XCTAssertEqual(actualValue, expectedValue)
    }

}

private extension BaseSearchPresenterTests {
    func createSut(callback: @escaping (SearchModel) -> Void = { _ in }) -> BaseSearchPresenter {
        view = BaseSearchMockView()
        return BaseSearchPresenter(view: view,
                                   items: BaseSearchStub.searchModel,
                                   callback: callback)
    }
}
