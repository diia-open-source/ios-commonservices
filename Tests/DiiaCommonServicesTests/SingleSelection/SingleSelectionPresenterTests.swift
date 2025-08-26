
import XCTest
@testable import DiiaCommonServices
@testable import DiiaCommonTypes

final class SingleSelectionPresenterTests: XCTestCase {
    var view: SingleSelectionMockView!

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
        let actualValue = sut.numberOfItems
        
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
        let actualValue = sut.item(at: .zero)

        // Assert
        XCTAssertEqual(actualValue?.title, expectedNameValue)
    }
    
    func test_presenter_itemSelected_worksCorrect() {
        // Arrange
        let sut = createSut()
        
        // Act
        sut.configureView()
        sut.itemSelected(at: .zero)

        // Assert
        XCTAssertTrue(view.isCloseModuleCalled)
    }
    
    func test_presenter_setSearch_worksCorrect() {
        // Arrange
        let sut = createSut()
        let expectedValue = 1
        
        // Act
        sut.configureView()
        sut.searchTextUpdated("test1")
        let actualValue = sut.numberOfItems
        
        // Assert
        XCTAssertTrue(view.isViewUpdateCalled)
        XCTAssertEqual(actualValue, expectedValue)
    }

    func test_presenter_headerSetUp_ifHeaderTitleNotNilAndNotEmpty() {
        let sut = createSut(header: "AnyNotEmptyHeaderTitle")
        sut.configureView()

        // Assert
        XCTAssertTrue(view.isSetupHeaderCalled)
    }

    func test_presenter_headerSetUp_ifHeaderTitleIsEmpty() {
        let sut = createSut(header: "")
        sut.configureView()

        // Assert
        XCTAssertTrue(view.isSetupHeaderCalled)
    }

    func test_presenter_headerSetUp_ifHeaderTitleIsNil() {
        let sut = createSut()
        sut.configureView()

        // Assert
        XCTAssertTrue(view.isSetupHeaderCalled)
    }
}

private extension SingleSelectionPresenterTests {
    private var searchItemsModels: [SearchItemModel] {
        [SearchItemModel(code: "1", title: "test1"),
         SearchItemModel(code: "2", title: "test2")]
    }

    func createSut(header: String? = nil, callback: @escaping (SearchItemModel) -> Void = { _ in }) -> SingleSelectionPresenter {
        view = SingleSelectionMockView()

        let configuration = SingleSelectionModuleConfiguration(
            headerTitle: header,
            items: searchItemsModels
        )

        return SingleSelectionPresenter(
            view: view,
            configuration: configuration,
            callback: callback
        )
    }
}
