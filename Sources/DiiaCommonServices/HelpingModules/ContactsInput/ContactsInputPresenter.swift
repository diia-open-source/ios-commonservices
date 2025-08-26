
import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol ContactsInputAction: BasePresenter {
    func validateWhileEditing(phone: String, email: String)
    func validateWhenEdited(phone: String, email: String)
    func isAvailableNextButton() -> Bool
    func buttonTitle() -> String
    func goNext()
    func openContextMenu()
    func screenCode() -> String
    func resourceId() -> String?
}

final class ContactsInputPresenter: ContactsInputAction {

	// MARK: - Properties
    unowned var view: ContactsInputView
    
    private let contextMenuProvider: ContextMenuProviderProtocol
    private let contactsHandler: ContactsInputHandler
    private let stepCounter: StepCounter?
    private let urlOpener: URLOpenerProtocol?
    
    private var didRetry = false
    
    private var contactTypes: Set<ContactInputType>
    private var phone = ""
    private var email = ""
    
    // MARK: - Init
    init(view: ContactsInputView,
         contextMenuProvider: ContextMenuProviderProtocol,
         contactsHandler: ContactsInputHandler,
         stepCounter: StepCounter?,
         urlOpener: URLOpenerProtocol?) {
        self.view = view
        self.contextMenuProvider = contextMenuProvider
        self.stepCounter = stepCounter
        self.contactsHandler = contactsHandler
        self.contactTypes = contactsHandler.availableContactTypes()
        self.urlOpener = urlOpener
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.setTitle(contactsHandler.title())
        view.setStepCounter(stepCounter)
        view.setButtonAvailability(isAvailable: false)
        view.setContextMenuAvailable(isAvailable: contextMenuProvider.hasContextMenu())
        view.setAvailableContactTypes(contactTypes: contactTypes)
        view.setURLOpener(urlOpener: urlOpener)
        contactsHandler.fetchContactsInputInfo(in: view)
    }
    
    func validateWhileEditing(phone: String, email: String) {
        let phoneCleared = phone.phoneCleared
        
        self.phone = phoneCleared
        self.email = email
        
        view.setButtonAvailability(isAvailable: isAvailableNextButton())
    }
    
    func isAvailableNextButton() -> Bool {
        return (!contactTypes.contains(.email) || email.isValidNonRussianEmail)
        && (!contactTypes.contains(.phone) || phone.isValidUkrainianMobileNumber)
    }
    
    func buttonTitle() -> String {
        return contactsHandler.buttonTitle() ?? R.Strings.general_next.localized()
    }
    
    func validateWhenEdited(phone: String, email: String) {
        let phoneCleared = phone.phoneCleared
        
        self.phone = phoneCleared
        self.email = email
        view.setButtonAvailability(isAvailable: isAvailableNextButton())
        
        if !phone.isEmpty {
            view.highlightPhone(isCorrect: phoneCleared.isValidUkrainianMobileNumber)
        }
        if !email.isEmpty {
            view.highlightEmail(isCorrect: email.isValidEmail, isNotRuMail: email.isValidNonRussianEmail)
        }
    }
    
    func goNext() {
        sendContacts()
    }
    
    func openContextMenu() {
        guard contextMenuProvider.hasContextMenu() else { return }
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func screenCode() -> String {
        return contactsHandler.screenCode()
    }
    
    func resourceId() -> String? {
        return contactsHandler.resourceId()
    }
    
    // MARK: - Private Methods
    private func sendContacts() {
        contactsHandler.sendContacts(
            contacts: [
                .phone: phone,
                .email: email
            ],
            in: view
        )
    }
}

fileprivate extension String {
    var phoneCleared: String {
        return "38\(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())"
    }
}
