import XCTest
import DiiaCommonTypes
@testable import DiiaCommonServices

class GeneralErrorPresenterTests: XCTestCase {
    
    var view: GeneralErrorMockView!
    
    override func tearDown() {
        view = nil
        super.tearDown()
    }
    
    func test_presenter_configureView_worksCorrect() {
        // Arrange
        let sut = createSut(viewModel: GeneralErrorStub.getViewModel())
        
        // Act
        sut.configureView()
        
        // Assert
        XCTAssertTrue(view.isViewConfigured)
    }
    
    func test_presenter_onAction_worksCorrect() {
        // Arrange
        let expectation = self.expectation(description: "call callback on button action")
        var isCallbackCalled = false
        let callback: Callback = {
            isCallbackCalled.toggle()
            expectation.fulfill()
        }
        let sut = createSut(viewModel: GeneralErrorStub.getViewModel(buttonAction: callback))
        
        // Act
        sut.onAction()
        
        // Assert
        waitForExpectations(timeout: 0.3)
        XCTAssertTrue(isCallbackCalled)
    }
    
    func test_presenter_onClose_worksCorrect() {
        // Arrange
        let expectation = self.expectation(description: "call callback on close action")
        var isCallbackCalled = false
        let callback: Callback = {
            isCallbackCalled.toggle()
            expectation.fulfill()
        }
        let sut = createSut(viewModel: GeneralErrorStub.getViewModel(closeAction: callback))
        
        // Act
        sut.onClose()
        
        // Assert
        waitForExpectations(timeout: 0.3)
        XCTAssertTrue(isCallbackCalled)
    }
}

private extension GeneralErrorPresenterTests {
    func createSut(viewModel: GeneralErrorViewModel) -> GeneralErrorPresenter {
        view = GeneralErrorMockView()
        return GeneralErrorPresenter(view: view,
                                     viewModel: viewModel)
    }
}

