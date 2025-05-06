import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol ContactsInputView: ContactsInputViewProtocol, RatingFormHolder {
    func setStepCounter(_ stepCounter: StepCounter?)
    func setAvailableContactTypes(contactTypes: Set<ContactInputType>)
    func setButtonAvailability(isAvailable: Bool)
    func setURLOpener(urlOpener: URLOpenerProtocol?)
    func highlightPhone(isCorrect: Bool)
    func highlightEmail(isCorrect: Bool, isNotRuMail: Bool)
}

final class ContactsInputViewController: UIViewController, RatingFormHolder {

    // MARK: - Outlets
    @IBOutlet weak private var topView: TopNavigationView!
    
    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var attentionView: ParameterizedAttentionView!
    @IBOutlet weak private var scrollView: ExtendedScrollView!
    @IBOutlet weak private var stackView: UIStackView!
    
    @IBOutlet weak private var phoneView: UIView!
    @IBOutlet weak private var phoneTitleLabel: UILabel!
    @IBOutlet weak private var phoneMaskLabel: UILabel!
    @IBOutlet weak private var phoneTextField: UITextField!
    @IBOutlet weak private var phoneSeparatorView: UIView!
    @IBOutlet weak private var wrongPhoneLabel: UILabel!
    
    @IBOutlet weak private var emailView: UIView!
    @IBOutlet weak private var emailTitleLabel: UILabel!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var emailSeparatorView: UIView!
    @IBOutlet weak private var wrongEmailLabel: UILabel!
    
    @IBOutlet private weak var actionButton: LoadingStateButton!
    @IBOutlet private weak var actionButtonBottomConstraint: NSLayoutConstraint!
    
    private var keyboardHandler: KeyboardHandler?
    private var urlOpener: URLOpenerProtocol?

	// MARK: - Properties
	var presenter: ContactsInputAction!

	// MARK: - Init
	init() {
        super.init(nibName: ContactsInputViewController.className, bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
    }
    
    private func initialSetup() {
        phoneTextField.delegate = self
        emailTextField.delegate = self
        
        wrongPhoneLabel.isHidden = true
        wrongEmailLabel.isHidden = true
        wrongPhoneLabel.textColor = Constants.errorColor
        wrongEmailLabel.textColor = Constants.errorColor
        phoneSeparatorView.backgroundColor = Constants.separatorColor
        emailSeparatorView.backgroundColor = Constants.separatorColor

        phoneTextField.returnKeyType = .done
        emailTextField.returnKeyType = .done
        
        attentionView.isHidden = true
        
        setupTopView()
        setupTexts()
        setupFonts()
        setupButton()
        setupKeyboardHandle()
    }
    
    private func setupTopView() {
        topView.setupTitle(title: R.Strings.contacts_input_title.localized())
        topView.setupOnClose(callback: { [weak self] in
            self?.closeModule(animated: true)
        })
    }
    
    private func setupTexts() {
        headerLabel.text = R.Strings.contacts_input_title.localized()
        descriptionLabel.text = R.Strings.contacts_input_filled_from_bank_id.localized()
        
        phoneTitleLabel.text = R.Strings.contacts_input_contact_phone.localized()
        phoneMaskLabel.text = Constants.phonePrefix
        wrongPhoneLabel.text = R.Strings.contacts_input_wrong_phone.localized()
        
        emailTitleLabel.text = R.Strings.contacts_input_contact_email.localized()
        wrongEmailLabel.text = R.Strings.contacts_input_wrong_email.localized()
    }
    
    private func setupFonts() {
        headerLabel.font = FontBook.detailsTitleFont
        descriptionLabel.font = FontBook.usualFont
        
        phoneTitleLabel.font = FontBook.smallTitle
        phoneMaskLabel.font = FontBook.bigText
        phoneTextField.font = FontBook.bigText
        wrongPhoneLabel.font = FontBook.smallTitle
        
        emailTitleLabel.font = FontBook.smallTitle
        emailTextField.font = FontBook.bigText
        wrongEmailLabel.font = FontBook.smallTitle
    }
    
    private func setupButton() {
        actionButton.setLoadingState(.disabled, withTitle: presenter.buttonTitle())
        actionButton.contentEdgeInsets = Constants.buttonInsets
        actionButton.titleLabel?.font = FontBook.bigText
        actionButtonBottomConstraint.constant = DiiaUIComponents.AppConstants.Layout.buttonBottomOffset
    }
    
    private func setupKeyboardHandle() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapRecognizer)
        scrollView.isUserInteractionEnabled = true
        keyboardHandler = KeyboardHandler(type: .constraint(
            constraint: actionButtonBottomConstraint,
            withoutInset: DiiaUIComponents.AppConstants.Layout.buttonBottomOffset,
            keyboardInset: DiiaUIComponents.AppConstants.Layout.buttonKeyboardOffset,
            superview: view))
    }
    
    // MARK: - Actions
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction private func nextClicked() {
        hideKeyboard()
        presenter.goNext()
    }
}

// MARK: - View logic
extension ContactsInputViewController: ContactsInputView {
    func screenCode() -> String {
        return presenter.screenCode()
    }
    
    func resourceId() -> String? {
        presenter.resourceId()
    }
    
    func setContextMenuAvailable(isAvailable: Bool) {
        topView.setupOnContext(callback: isAvailable ? { [weak self] in self?.presenter.openContextMenu() } : nil)
    }
    
    func setTitle(_ title: String?) {
        topView.setupTitle(title: title ?? "")
    }
    
    func setLoadingState(state: LoadingState) {
        topView.setupLoading(isActive: state == .loading)
        [scrollView, actionButton].forEach { $0.isHidden = state == .loading }
    }
    
    func setSendingState(state: LoadingState, title: String?) {
        let buttonState: LoadingStateButton.LoadingState = state == .loading
            ? .loading
            : presenter.isAvailableNextButton()
                ? .enabled
                : .disabled
        actionButton.setLoadingState(buttonState, withTitle: title ?? presenter.buttonTitle())
        emailTextField.isUserInteractionEnabled = state == .ready
        phoneView.isUserInteractionEnabled = state == .ready
    }
    
    func setContacts(contacts: ContactsInputModel) {
        headerLabel.text = contacts.title
        descriptionLabel.text = contacts.description ?? contacts.text
        
        if let attentionMessage = contacts.attentionMessage {
            attentionView.configure(with: attentionMessage, urlOpener: urlOpener)
        }
        
        headerLabel.isHidden = contacts.title == nil
        descriptionLabel.isHidden = contacts.description == nil && contacts.text == nil
        attentionView.isHidden = contacts.attentionMessage == nil

        let phone = (contacts.phone ?? contacts.phoneNumber)?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined().removingPhonePrefix()
        let phoneNumber = phone?.formattedPhoneNumber(mask: Constants.phoneMask) ?? ""
        phoneTextField.text = phoneNumber
        let email = contacts.email ?? ""
        emailTextField.text = email
        
        presenter.validateWhileEditing(phone: phoneNumber, email: email)
    }
    
    func setStepCounter(_ stepCounter: StepCounter?) {
        topView.setStepCounter(stepCounter)
    }
    
    func setAvailableContactTypes(contactTypes: Set<ContactInputType>) {
        phoneView.isHidden = !contactTypes.contains(.phone)
        emailView.isHidden = !contactTypes.contains(.email)
    }
    
    func setButtonAvailability(isAvailable: Bool) {
        actionButton.setLoadingState(isAvailable ? .enabled : .disabled)
    }
    
    func setURLOpener(urlOpener: URLOpenerProtocol?) {
        self.urlOpener = urlOpener
    }

    func highlightPhone(isCorrect: Bool) {
        wrongPhoneLabel.isHidden = isCorrect
        if isCorrect {
            phoneSeparatorView.backgroundColor = Constants.separatorColor
            phoneTextField.textColor = .black
            phoneMaskLabel.textColor = .black
        } else {
            phoneSeparatorView.backgroundColor = Constants.errorColor
            phoneTextField.textColor = Constants.errorColor
            phoneMaskLabel.textColor = Constants.errorColor
        }
    }
    
    func highlightEmail(isCorrect: Bool, isNotRuMail: Bool) {
        let isCorrectEmailFormat: Bool = isCorrect && isNotRuMail
        wrongEmailLabel.isHidden = isCorrectEmailFormat
        if !isCorrectEmailFormat {
            wrongEmailLabel.text = !isCorrect ?
            R.Strings.contacts_input_wrong_email.localized() :
            R.Strings.contacts_input_wrong_ru_email.localized()
        }
        if isCorrectEmailFormat {
            emailSeparatorView.backgroundColor = Constants.separatorColor
            emailTextField.textColor = .black
        } else {
            emailSeparatorView.backgroundColor = Constants.errorColor
            emailTextField.textColor = Constants.errorColor
        }
    }
}

extension ContactsInputViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            let previousTextRange = textField.selectedTextRange
            let phoneMaskedString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string).formattedPhoneNumber(mask: Constants.phoneMask)
            textField.text = phoneMaskedString
            presenter.validateWhileEditing(phone: phoneMaskedString, email: emailTextField.text ?? "")
            
            textField.handleCursorOnPhoneNumber(selectedTextRange: previousTextRange, replacementString: string)
            return false
        }

        let emailString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        presenter.validateWhileEditing(phone: phoneTextField.text ?? "", email: emailString)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneTextField {
            phoneMaskLabel.textColor = .black
        }
        textField.textColor = .black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let phoneNumber = (phoneTextField.text ?? "").formattedPhoneNumber(mask: Constants.phoneMask)
        let email = emailTextField.text ?? ""
        
        presenter.validateWhenEdited(phone: phoneNumber, email: email)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Constants
extension ContactsInputViewController {
    private enum Constants {
        static let phonePrefix = "+38"
        static let phoneMask = "(XXX) XXX XX XX"

        static let separatorColor = UIColor("#000000").withAlphaComponent(0.3)
        static let errorColor = UIColor("#CA2F28")
        static let buttonInsets = UIEdgeInsets.init(top: 0, left: 62, bottom: 0, right: 62)
    }
}

extension UITextField {
    func handleCursorOnPhoneNumber(selectedTextRange: UITextRange?, replacementString string: String) {
        guard let textRange = selectedTextRange else { return }
        
        let cursorPosition = offset(from: beginningOfDocument, to: textRange.start)
        var offset = PhoneMaskConstants.Offset.start.rawValue
        let singleOffset = PhoneMaskConstants.Offset.single.rawValue
        let doubleOffset = PhoneMaskConstants.Offset.double.rawValue
        
        // when the user deletes one or more characters, the replacement string is empty.
        if string.isEmpty {
            // add left offset for deleted character
            offset -= singleOffset
            if PhoneMaskConstants.subtractPoints.contains(cursorPosition) {
                // if cursor on mask character, then add additional offset
                offset -= singleOffset
            } else if cursorPosition == PhoneMaskConstants.doubleSubtractPoint {
                // but there is also a point where two mask characters are set together - ') '
                offset -= doubleOffset
            }
        } else {
            // add right offset according to added characters count
            offset = string.count
            if PhoneMaskConstants.addPoints.contains(cursorPosition) {
                offset += singleOffset
            } else if cursorPosition == PhoneMaskConstants.doubleAddPoint {
                offset += doubleOffset
            }
        }
        
        if let newPosition = position(from: textRange.start, offset: offset) {
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
    }
        
    private enum PhoneMaskConstants {
        enum Offset: Int {
            case start = 0
            case single = 1
            case double = 2
        }
        
        // We need to add or subtract offset on specific points as we have additional symbols '(', ')', space
        static let addPoints = [0, 9, 12]
        static let subtractPoints = [10, 13]
        static let doubleAddPoint = 4
        static let doubleSubtractPoint = 6
    }
}
