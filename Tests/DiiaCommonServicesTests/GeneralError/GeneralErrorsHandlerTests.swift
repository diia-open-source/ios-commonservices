import XCTest
import DiiaCommonTypes
@testable import DiiaCommonServices

class GeneralErrorsHandlerTests: XCTestCase {
    
    var view: AnyGeneralErrorMockView!
    
    override func setUp() {
        super.setUp()
        view = AnyGeneralErrorMockView()
    }
    
    override func tearDown() {
        view = nil
        super.tearDown()
    }
    
    func test_presenter_processWithRetry_worksCorrect() {
        performOneTestWithSpecificAct { [weak self] in
            guard let self = self else { return }
            GeneralErrorsHandler.process(error: .noInternet,
                                         with: {},
                                         didRetry: false,
                                         in: self.view)
        }
    }
    
    func test_presenter_processWithDefaultForceClose_worksCorrect() {
        performOneTestWithSpecificAct { [weak self] in
            guard let self = self else { return }
            GeneralErrorsHandler.process(error: .noInternet, in: self.view)
        }
    }
    
    func test_presenter_processWithForceClose_worksCorrect() {
        performOneTestWithSpecificAct { [weak self] in
            guard let self = self else { return }
            GeneralErrorsHandler.process(error: .noInternet, in: self.view, forceClose: true)
        }
    }
    
    func test_presenter_processWithCustomClose_worksCorrect() {
        performOneTestWithSpecificAct { [weak self] in
            guard let self = self else { return }
            GeneralErrorsHandler.process(error: .noInternet,
                                         with: {},
                                         in: self.view,
                                         closeCallback: {})
        }
    }
    
    // MARK: - Private helper
    private func performOneTestWithSpecificAct(_ act: Callback) {
        // Arrange
        let expectation = self.expectation(description: "process")
        var isGeneralErrorShowing = false
        view.onGeneralErrorShow = { isGeneralErrorVisible in
            isGeneralErrorShowing = isGeneralErrorVisible
            expectation.fulfill()
        }
        
        // Act
        act()
        
        // Assert
        waitForExpectations(timeout: 1)
        XCTAssertTrue(isGeneralErrorShowing)
    }
}
