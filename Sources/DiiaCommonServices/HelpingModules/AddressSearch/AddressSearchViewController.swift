
import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

public protocol AddressSearchView: BaseView, RatingFormHolder {
    func setTitle(title: String)
    func setContextMenuAvailable(isAvailable: Bool)
    func setHeader(header: String)
    func setDescription(description: String)
    func setAttention(attention: ParameterizedAttentionMessage)
    func setState(state: LoadingState)
    func setSteps(steps: [AddressRequestStep])
    func appendSteps(steps: [AddressRequestStep])
    func removeInputs(after index: Int)
    func setButtonAvailability(isAvailable: Bool)
    func setButtonTitle(title: String)
    func setButtonState(isLoading: Bool)
}

final class AddressSearchViewController: UIViewController {
    
	// MARK: - Properties
	var presenter: AddressSearchAction!

    // MARK: - Outlets
    @IBOutlet weak private var topView: TopNavigationView!
    
    @IBOutlet weak private var scrollView: ExtendedScrollView!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var containerView: UIView!

    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var loadingIndicator: UIProgressView!
    @IBOutlet weak private var attentionView: ParameterizedAttentionView!

    @IBOutlet private weak var actionButton: LoadingStateButton!
    @IBOutlet private weak var actionButtonBottomConstraint: NSLayoutConstraint!
    
    private var keyboardHandler: KeyboardHandler?
    
	// MARK: - Init
	init() {
        super.init(nibName: AddressSearchViewController.className, bundle: Bundle.module)
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
        headerLabel.font = FontBook.detailsTitleFont
        setupTopView()
        setupButton()
        setupGestures()
        keyboardHandler = KeyboardHandler(type: .constraint(constraint: actionButtonBottomConstraint, withoutInset: AppConstants.Layout.buttonBottomOffset, keyboardInset: AppConstants.Layout.buttonKeyboardOffset, superview: view))
        setDescription(description: "")
        attentionView.isHidden = true
    }
    
    private func setupTopView() {
        topView.setupTitle(title: R.Strings.address_search_title.localized())
        topView.setupOnClose(callback: { [weak self] in
            self?.closeModule(animated: true)
        })
    }
    
    private func setupButton() {
        actionButton.setLoadingState(.disabled, withTitle: R.Strings.general_save.localized())
        actionButton.titleLabel?.font = FontBook.bigText
        actionButtonBottomConstraint.constant = AppConstants.Layout.buttonBottomOffset
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction private func select() {
        presenter.select()
    }
    
    private func makeDropView(for parameter: AddressRequestParameter) -> DropContentView {
        let dropView = DropContentView()
        let contextMenuProvider = presenter.getContextMenuProvider()

        dropView.configure(
            title: parameter.parameter.label,
            placeholder: parameter.parameter.hint ?? parameter.parameter.label) { [weak self] in
                let items = (parameter.parameter.source?.items ?? []).map {
                    SearchItemModel(
                        code: $0.id,
                        title: $0.name,
                        additionalText: nil,
                        searchText: nil,
                        isEnabled: !($0.disabled == true)
                    )
                }

                let configuration = SingleSelectionModuleConfiguration(
                    headerTitle: parameter.parameter.label,
                    items: items,
                    sorter: BaseSearchItemsSorter.byPositionRank,
                    placeholder: parameter.parameter.searchPlaceholder
                )

                self?.open(module: SingleSelectionModule(
                    configuration: configuration,
                    contextMenuProvider: contextMenuProvider,
                    callback: { [weak parameter, weak dropView] result in
                        guard let parameter = parameter,
                              let selectedItem = parameter.parameter.source?.items.first(where: { $0.id == result.code }),
                              let dropView = dropView
                        else { return }
                        
                        parameter.id = result.code
                        parameter.value = result.title
                        dropView.setupState(state: .selected(text: result.title))
                        
                        parameter.errorMessage = selectedItem.errorMessage
                        if let errorMessage = selectedItem.errorMessage {
                            dropView.setupState(state: .error(errorText: errorMessage))
                        }
                        parameter.onChange?()
                    }))
            }
        if let value = parameter.value {
            dropView.setupState(state: .selected(text: value))
        } else if parameter.parameter.source?.items.count ?? 0 > 0 {
            dropView.setupState(state: .enabled)
        } else {
            dropView.setupState(state: .disabled)
        }
        return dropView
    }
    
    private func makeTextView(for parameter: AddressRequestParameter) -> TitledTextFieldView {        
        let textView = TitledTextFieldView()
        
        var validators: [TextValidationErrorGenerator] = []
        if let validation = parameter.parameter.validation {
            validators = [.init(validationModel: validation)]
        }
        
        let viewModel = TitledTextFieldViewModel(
            title: parameter.parameter.label,
            placeholder: parameter.parameter.hint ?? parameter.parameter.label,
            validators: validators,
            mask: parameter.parameter.mask,
            onChangeText: { [weak parameter] text in
                parameter?.value = text
                parameter?.onChange?()
            }
        )
        if let mask = parameter.parameter.mask {
            viewModel.shouldChangeCharacters = TextInputFormatter.textFormatter(
                textField: textView.textField,
                mask: mask,
                onChange: { [weak parameter] text in
                    parameter?.value = text.removingMask(mask: mask)
                    parameter?.onChange?()
                }
            )
        }
        
        textView.configure(viewModel: viewModel)
        
        return textView
    }
}

// MARK: - View logic
extension AddressSearchViewController: AddressSearchView {
    
    func screenCode() -> String {
        return presenter.getScreenCode() ?? Constants.screenCode
    }
    
    func setTitle(title: String) {
        topView.setupTitle(title: title)
    }
    
    func setContextMenuAvailable(isAvailable: Bool) {
        topView.setupOnContext(callback: isAvailable ? { [weak self] in self?.presenter.openContextMenu() } : nil)
    }
    
    func setHeader(header: String) {
        headerLabel.text = header
        headerLabel.isHidden = header.count == 0
    }
    
    func setDescription(description: String) {
        descriptionLabel.text = description
        descriptionLabel.isHidden = description.count == 0
    }
    
    func setAttention(attention: ParameterizedAttentionMessage) {
        attentionView.configure(with: attention, urlOpener: URLOpenerImpl())
        attentionView.isHidden = false
    }
    
    func setButtonAvailability(isAvailable: Bool) {
        actionButton.setLoadingState(isAvailable ? .enabled : .disabled)
    }
    
    func setSteps(steps: [AddressRequestStep]) {
        stackView.safelyRemoveArrangedSubviews()
        appendSteps(steps: steps)
    }
    
    func appendSteps(steps: [AddressRequestStep]) {
        steps.forEach { step in
            var index = 0
            while index < step.parameters.count {
                let parameter = step.parameters[index]
                appendStepParameter(parameter: parameter, to: stackView)
                index += 1
            }
        }
    }
    
    private func appendStepParameter(parameter: AddressRequestParameter, to stackView: UIStackView) {
        switch parameter.parameter.input {
        case .list, .singleCheck:
            stackView.addArrangedSubview(makeDropView(for: parameter))
        case .textField:
            stackView.addArrangedSubview(makeTextView(for: parameter))
        }
    }
    
    func removeInputs(after index: Int) {
        if stackView.arrangedSubviews.count > index {
            let indexes = stackView.arrangedSubviews.indices.suffix(from: index)
            indexes.reversed().forEach { index in
                stackView.safelyRemoveArrangedSubview(subview: stackView.arrangedSubviews[index])
            }
        }
    }
    
    func removeSteps(at indexes: [Int]) {
        indexes.forEach { index in
            if stackView.arrangedSubviews.count < index {
                stackView.safelyRemoveArrangedSubview(subview: stackView.arrangedSubviews[index])
            }
        }
    }
    
    func setState(state: LoadingState) {
        let isActive = state == .loading
        let contentIsEmpty = stackView.arrangedSubviews.isEmpty
        containerView.isHidden = contentIsEmpty
        actionButton.isHidden = contentIsEmpty
        topView.setupLoading(isActive: contentIsEmpty && isActive)
        
        loadingIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }
        loadingIndicator.setProgress(0.0, animated: false)
        loadingIndicator.isHidden = !isActive
        
        if !isActive { return }
        self.loadingIndicator.layoutIfNeeded()
        self.loadingIndicator.setProgress(1.0, animated: false)
        UIView.animate(
            withDuration: Constants.progressAnimationDuration,
            delay: 0,
            options: [.repeat],
            animations: { [unowned self] in self.loadingIndicator.layoutIfNeeded() }
        )
    }
    
    func setButtonState(isLoading: Bool) {
        actionButton.setLoadingState(isLoading ? .loading : .enabled)
    }
    
    func setButtonTitle(title: String) {
        actionButton.setLoadingState(actionButton.loadingState, withTitle: title)
    }
}

// MARK: - Constants
extension AddressSearchViewController {
    private enum Constants {
        static let progressAnimationDuration: TimeInterval = 1.5
        static var keyboardButtonBottomOffset: CGFloat = 8
        static var horizontalStackSpacing: CGFloat = 24
        static let screenCode = "registrationPlace"
    }
}
