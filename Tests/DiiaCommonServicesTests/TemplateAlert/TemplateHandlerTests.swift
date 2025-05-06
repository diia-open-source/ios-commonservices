import XCTest
import DiiaCommonTypes
@testable import DiiaCommonServices

class TemplateHandlerTests: XCTestCase {
    
    var routingHandler: RoutingHandlerMock!
    var deepLinkManager: DeepLinkManagerMock!
    var urlOpener: URLOpenerMock!
    var view: AnyTemplateAlertMockView!
    
    override func tearDown() {
        routingHandler = nil
        deepLinkManager = nil
        urlOpener = nil
        view = nil
        super.tearDown()
    }
    
    func test_presenter_handleDefaultAction_worksCorrect() {
        // Arrange
        configureSut()
        let expectation = self.expectation(description: "handler handle default action")
        var isTemlateAlertShowing = false
        view.onTemplateShow = { isTemlateAlertVisible in
            isTemlateAlertShowing = isTemlateAlertVisible
            expectation.fulfill()
        }

        // Act
        TemplateHandler.handle(.generalErrorAlert,
                               in: view,
                               callback: { _ in })

        // Assert
        waitForExpectations(timeout: 1)
        XCTAssertTrue(isTemlateAlertShowing)
    }
    
    func test_presenter_handleInternalLinkAction_worksCorrect() {
        // Arrange
        configureSut()
        let expectation = self.expectation(description: "handler handle internal link")
        var isTemlateAlertShowing = false
        view.onTemplateShow = { isTemlateAlertVisible in
            isTemlateAlertShowing = isTemlateAlertVisible
            expectation.fulfill()
        }
        
        // Act
        TemplateHandler.handle(.init(type: .largeAlert,
                                     isClosable: false,
                                     data: .init(icon: nil,
                                                 title: "title_test",
                                                 description: nil,
                                                 mainButton: .init(title: nil,
                                                                   icon: nil,
                                                                   action: .internalLink,
                                                                   resource: "https://test.com"),
                                                 alternativeButton: nil)),
                               in: view,
                               callback: { _ in })

        // Assert
        waitForExpectations(timeout: 1)
        XCTAssertTrue(isTemlateAlertShowing)
        XCTAssertTrue(deepLinkManager.isParseCalled)
    }
    
    func test_presenter_handleExternalLinkAction_worksCorrect() {
        // Arrange
        configureSut()
        let expectation = self.expectation(description: "handler handle external link")
        var isTemlateAlertShowing = false
        view.onTemplateShow = { isTemlateAlertVisible in
            isTemlateAlertShowing = isTemlateAlertVisible
            expectation.fulfill()
        }
        
        // Act
        TemplateHandler.handle(.init(type: .middleLeftAlignAlert,
                                     isClosable: false,
                                     data: .init(icon: nil,
                                                 title: "title_test",
                                                 description: nil,
                                                 mainButton: .init(title: nil,
                                                                   icon: nil,
                                                                   action: .externalLink,
                                                                   resource: "https://test.com"),
                                                 alternativeButton: nil)),
                               in: view,
                               callback: { _ in })

        // Assert
        waitForExpectations(timeout: 1)
        XCTAssertTrue(isTemlateAlertShowing)
        XCTAssertTrue(urlOpener.isOpenUrlCalled)
    }
    
    func test_presenter_handleCustomTemplate_worksCorrect() {
        // Arrange
        configureSut()
        let expectation = self.expectation(description: "handler handle custom template")
        var isTemlateAlertShowing = false
        view.onTemplateShow = { isTemlateAlertVisible in
            isTemlateAlertShowing = isTemlateAlertVisible
            expectation.fulfill()
        }
        
        // Act
        TemplateHandler.handle(.init(type: .middleCenterBlackButtonAlert,
                                     isClosable: false,
                                     data: .init(icon: nil,
                                                 title: "title_test",
                                                 description: nil,
                                                 mainButton: .init(title: nil,
                                                                   icon: nil,
                                                                   action: .close),
                                                 alternativeButton: nil)),
                               in: view,
                               callback: { _ in })

        // Assert
        waitForExpectations(timeout: 1)
        XCTAssertTrue(isTemlateAlertShowing)
    }
    
    func test_presenter_handleGlobalDefaultAction_worksCorrect() {
        performOneTestWithSpecificTemplate(.middleCenterAlignAlert)
    }
    
    func test_presenter_handleGlobalLargeTemplate_worksCorrect() {
        performOneTestWithSpecificTemplate(.largeAlert)
    }
    
    func test_presenter_handleGlobalMiddleLeftTemplate_worksCorrect() {
        performOneTestWithSpecificTemplate(.middleLeftAlignAlert)
    }
    
    func test_presenter_handleGlobalCustomTemplate_worksCorrect() {
        performOneTestWithSpecificTemplate(.middleCenterBlackButtonAlert)
    }
    
    // MARK: - Private helper
    private func performOneTestWithSpecificTemplate(_ type: AlertType) {
        // Arrange
        configureSut()
        
        // Act
        TemplateHandler.handleGlobal(.init(type: type, isClosable: false, data: .init(icon: nil,
                                                                                      title: "title_test",
                                                                                      description: nil,
                                                                                      mainButton: .init(title: nil,
                                                                                                        icon: nil,
                                                                                                        action: .close),
                                                                                      alternativeButton: nil)),
                                     callback: { _ in })
        
        // Assert
        XCTAssertTrue(routingHandler.isPerformOrDeferCalled)
    }
}

private extension TemplateHandlerTests {
    func configureSut() {
        routingHandler = RoutingHandlerMock()
        deepLinkManager = DeepLinkManagerMock()
        urlOpener = URLOpenerMock()
        view = AnyTemplateAlertMockView()
        TemplateHandler.setup(context: .init(router: routingHandler,
                                             deepLink: deepLinkManager,
                                             communicationHelper: urlOpener))
    }
}

