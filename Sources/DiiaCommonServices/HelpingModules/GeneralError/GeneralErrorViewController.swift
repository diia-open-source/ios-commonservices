
import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol GeneralErrorView: BaseView {
    func configure(with viewModel: GeneralErrorViewModel)
}

final class GeneralErrorViewController: UIViewController, ChildSubcontroller, Storyboarded {
    
    // MARK: - Outlets
    @IBOutlet weak private var errorView: UIView!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var emojiLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var actionButton: VerticalRoundButton!

	// MARK: - Properties
	var presenter: GeneralErrorAction!
    weak var container: ContainerProtocol?

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        setupAccessibility()
        presenter.configureView()
    }
    
    private func initialSetup() {
        errorView.layer.cornerRadius = Constants.cornerRadius
        errorView.layer.masksToBounds = true
        
        emojiLabel.font = FontBook.bigEmoji
        titleLabel.font = FontBook.cardsHeadingFont
        descriptionLabel.font = FontBook.usualFont
        actionButton.layer.borderWidth = Constants.borderWidth
        actionButton.layer.borderColor = UIColor.black.cgColor
        actionButton.contentEdgeInsets = Constants.buttonInsets
        
        actionButton.setTitleColor(.black, for: .normal)
        actionButton.titleLabel?.font = FontBook.smallHeadingFont
    }
    
    private func setupAccessibility() {
        UIAccessibility.post(notification: .screenChanged, argument: self)
        
        emojiLabel.isAccessibilityElement = false
        
        titleLabel.isAccessibilityElement = true
        
        descriptionLabel.isAccessibilityElement = true
        
        actionButton.isAccessibilityElement = true
        actionButton.accessibilityTraits = .button
        
        closeButton.isAccessibilityElement = true
        closeButton.accessibilityTraits = .button
        closeButton.accessibilityLabel = R.Strings.general_accessibility_close.localized()
    }
    
    // MARK: - Private Methods
    @IBAction private func close(_ sender: UIButton) {
        presenter.onClose()
        
        container?.close()
    }
    
    @IBAction private func actionButtonTapped() {
        presenter.onAction()
        
        container?.close()
    }
}

// MARK: - View logic
extension GeneralErrorViewController: GeneralErrorView {
    func configure(with viewModel: GeneralErrorViewModel) {
        titleLabel.text = viewModel.error.localizedDescription
        titleLabel.accessibilityLabel = viewModel.error.localizedDescription
        
        descriptionLabel.isHidden = viewModel.error.localizedDetails == nil
        descriptionLabel.text = viewModel.error.localizedDetails
        descriptionLabel.accessibilityLabel = viewModel.error.localizedDetails
        
        let buttonTitle = viewModel.isRetryAllowed
        ? (viewModel.buttonTitle ?? R.Strings.general_retry.localized())
        : (viewModel.buttonTitle ?? R.Strings.general_ok.localized())
        
        actionButton.setTitle(buttonTitle, for: .normal)
        
        closeButton.accessibilityLabel = R.Strings.error_close.localized()
        closeButton.isHidden = viewModel.notClosable
            ? true
            : !viewModel.isRetryAllowed
    }
}

// MARK: - Constants
extension GeneralErrorViewController {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 2
        static let buttonInsets = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 40)
    }
}
