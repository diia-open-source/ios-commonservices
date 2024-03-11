import XCTest
import DiiaCommonTypes
@testable import DiiaCommonServices

class TemplateAlertPresenterTests: XCTestCase {
    
    var view: TemplateAlertMockView!
    
    override func tearDown() {
        view = nil
        super.tearDown()
    }
    
    func test_presenter_configureView_worksCorrect() {
        // Arrange
        let sut = createSut()
        
        // Act
        sut.configureView()
        
        // Assert
        XCTAssertTrue(view.isViewConfigured)
    }
    
    func test_presenter_close_worksCorrect() {
        // Arrange
        let sut = createSut()
        
        // Act
        sut.close()
        
        // Assert
        XCTAssertTrue(view.isCloseCalled)
    }
    
    func test_presenter_onMainButton_worksCorrect() {
        // Arrange
        let expectation = self.expectation(description: "call callback on main button")
        var isCallbackCalled = false
        let callback: (AlertTemplateAction) -> Void = { _ in
            isCallbackCalled.toggle()
            expectation.fulfill()
        }
        let sut = createSut(callback: callback)
        
        // Act
        sut.onMainButton()
        
        // Assert
        waitForExpectations(timeout: 0.3)
        XCTAssertTrue(isCallbackCalled)
        XCTAssertTrue(view.isCloseCalled)
    }
    
    func test_presenter_onAlternativeButton_worksCorrect() {
        // Arrange
        let expectation = self.expectation(description: "call callback on alternative button")
        var isCallbackCalled = false
        let callback: (AlertTemplateAction) -> Void = { _ in
            isCallbackCalled.toggle()
            expectation.fulfill()
        }
        let sut = createSut(callback: callback)
        
        // Act
        sut.onAlternativeButton()
        
        // Assert
        waitForExpectations(timeout: 0.3)
        XCTAssertTrue(isCallbackCalled)
        XCTAssertTrue(view.isCloseCalled)
    }
}

private extension TemplateAlertPresenterTests {
    func createSut(callback: @escaping (AlertTemplateAction) -> Void = { _ in }) -> TemplateAlertPresenter {
        view = TemplateAlertMockView()
        return TemplateAlertPresenter(view: view,
                                      viewModel: .init(template: AlertTemplateStub.alert),
                                      callback: callback,
                                      onClose: { })
    }
}
