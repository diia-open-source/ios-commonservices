import XCTest
@testable import DiiaCommonServices

class ContactsInputPresenterTests: XCTestCase {
    
    var view: ContactsInputMockView!
    var contextMenuProvider: ContextMenuProviderMock!
    var contactsInputHandler: ContactsInputHandlerMock!
    
    override func tearDown() {
        view = nil
        contextMenuProvider = nil
        contactsInputHandler = nil
        super.tearDown()
    }
    
    func test_presenter_configureView_worksCorrect() {
        // Arrange
        let sut = createSut()
        
        // Act
        sut.configureView()
        
        // Assert
        XCTAssertTrue(view.isTitleConfigured)
        XCTAssertTrue(view.isStepCounterConfigured)
        XCTAssertTrue(view.isButtonAvailabilityConfigured)
        XCTAssertTrue(view.isContextMenuAvailabilityConfigured)
        XCTAssertTrue(contextMenuProvider.hasContextMenuReturnValue)
        XCTAssertTrue(view.isAvailableContactTypesConfigured)
        XCTAssertTrue(view.isURLOpenerConfigured)
        XCTAssertTrue(contactsInputHandler.isContactsInputInfoFetched)
    }
    
    func test_presenter_validateWhileEditing_worksCorrect() {
        // Arrange
        let sut = createSut()
        
        // Act
        sut.validateWhileEditing(phone: "+380000000000", email: "test@test.com")
        
        // Assert
        XCTAssertTrue(view.isButtonAvailabilityConfigured)
    }
    
    func test_presenter_validateWhenEdited_worksCorrect() {
        // Arrange
        let sut = createSut()
        
        // Act
        sut.validateWhenEdited(phone: "+380000000000", email: "test@test.com")
        
        // Assert
        XCTAssertTrue(view.isButtonAvailabilityConfigured)
        XCTAssertTrue(view.isHighlightPhoneCalled)
        XCTAssertTrue(view.isHighlightEmailCalled)
    }
    
    func test_presenter_buttonTitle_worksCorrect() {
        // Arrange
        let sut = createSut()
        let expectedValue = "test_buttonTitle"
        
        // Act
        let actualValue = sut.buttonTitle()
        
        // Assert
        XCTAssertEqual(actualValue, expectedValue)
    }
    
    func test_presenter_goNext_worksCorrect() {
        // Arrange
        let sut = createSut()
        
        // Act
        sut.goNext()
        
        // Assert
        XCTAssertTrue(contactsInputHandler.isSendContactsCalled)
    }
    
    func test_presenter_openContextMenu_worksCorrect() {
        // Arrange
        let sut = createSut()
        
        // Act
        sut.openContextMenu()
        
        // Assert
        XCTAssertNotNil(contextMenuProvider.viewPassedInOpenContextMenu)
    }
    
    func test_presenter_screenCode_worksCorrect() {
        // Arrange
        let sut = createSut()
        let expectedValue = "contacts"
        
        // Act
        let actualValue = sut.screenCode()
        
        // Assert
        XCTAssertEqual(actualValue, expectedValue)
    }
    
    func test_presenter_resourceId_worksCorrect() {
        // Arrange
        let sut = createSut()
        
        // Act
        let actualValue = sut.resourceId()
        
        // Assert
        XCTAssertNil(actualValue)
    }
    
}

private extension ContactsInputPresenterTests {
    func createSut() -> ContactsInputPresenter {
        view = ContactsInputMockView()
        contextMenuProvider = ContextMenuProviderMock()
        contactsInputHandler = ContactsInputHandlerMock()
        return ContactsInputPresenter(view: view,
                                      contextMenuProvider: contextMenuProvider,
                                      contactsHandler: contactsInputHandler,
                                      stepCounter: nil,
                                      urlOpener: nil)
    }
}
