
import Foundation
import DiiaMVPModule
import DiiaUIComponents

public enum ContactInputType: String {
    case phone
    case email
    
    public func isValid(text: String) -> Bool {
        switch self {
        case .email:
            return text.isValidEmail && text.isValidNonRussianEmail
        case .phone:
            return text.isValidPhoneNumber
        }
    }
}

public protocol ContactsInputViewProtocol: BaseView {
    func setTitle(_ title: String?)
    func setContextMenuAvailable(isAvailable: Bool)
    func setLoadingState(state: LoadingState)
    func setSendingState(state: LoadingState, title: String?)
    func setContacts(contacts: ContactsInputModel)
}

public protocol ContactsInputHandler {
    func title() -> String
    func buttonTitle() -> String?
    func fetchContactsInputInfo(in view: ContactsInputViewProtocol)
    func sendContacts(contacts: [ContactInputType: String], in view: ContactsInputViewProtocol)
    func availableContactTypes() -> Set<ContactInputType>
    func screenCode() -> String
    func resourceId() -> String?
}

public extension ContactsInputHandler {
    func screenCode() -> String {
        return "contacts"
    }
    
    func resourceId() -> String? {
        return nil
    }
}
