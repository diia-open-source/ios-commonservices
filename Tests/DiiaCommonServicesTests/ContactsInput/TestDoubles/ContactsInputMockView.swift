import UIKit
import DiiaCommonTypes
import DiiaUIComponents
@testable import DiiaCommonServices

class ContactsInputMockView: UIViewController, ContactsInputView {
    private(set) var isTitleConfigured: Bool = false
    private(set) var isStepCounterConfigured: Bool = false
    private(set) var isButtonAvailabilityConfigured: Bool = false
    private(set) var isContextMenuAvailabilityConfigured: Bool = false
    private(set) var isAvailableContactTypesConfigured: Bool = false
    private(set) var isURLOpenerConfigured: Bool = false
    private(set) var isHighlightPhoneCalled: Bool = false
    private(set) var isHighlightEmailCalled: Bool = false
    
    func setStepCounter(_ stepCounter: StepCounter?) {
        isStepCounterConfigured.toggle()
    }
    
    func setAvailableContactTypes(contactTypes: Set<ContactInputType>) {
        isAvailableContactTypesConfigured.toggle()
    }
    
    func setButtonAvailability(isAvailable: Bool) {
        isButtonAvailabilityConfigured.toggle()
    }
    
    func setURLOpener(urlOpener: URLOpenerProtocol?) {
        isURLOpenerConfigured.toggle()
    }
    
    func highlightPhone(isCorrect: Bool) {
        isHighlightPhoneCalled.toggle()
    }
    
    func highlightEmail(isCorrect: Bool, isNotRuMail: Bool) {
        isHighlightEmailCalled.toggle()
    }
    
    func setTitle(_ title: String?) {
        isTitleConfigured.toggle()
    }
    
    func setContextMenuAvailable(isAvailable: Bool) {
        isContextMenuAvailabilityConfigured.toggle()
    }
    
    func setLoadingState(state: LoadingState) {}
    
    func setSendingState(state: LoadingState, title: String?) {}
    
    func setContacts(contacts: ContactsInputModel) {}
    
    func screenCode() -> String {
        return ""
    }
}
