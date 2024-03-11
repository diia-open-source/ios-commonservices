import Foundation
@testable import DiiaCommonServices

class ContactsInputHandlerMock: ContactsInputHandler {
    private(set) var isContactsInputInfoFetched: Bool = false
    private(set) var isSendContactsCalled: Bool = false
    
    func title() -> String {
        return ""
    }
    
    func buttonTitle() -> String? {
        return "test_buttonTitle"
    }
    
    func fetchContactsInputInfo(in view: ContactsInputViewProtocol) {
        isContactsInputInfoFetched.toggle()
    }
    
    func sendContacts(contacts: [ContactInputType : String], in view: ContactsInputViewProtocol) {
        isSendContactsCalled.toggle()
    }
    
    func availableContactTypes() -> Set<ContactInputType> {
        return [.phone]
    }
}
