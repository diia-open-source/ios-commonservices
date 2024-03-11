import UIKit
import DiiaUIComponents

public final class SmallAlertViewController: UIViewController, ChildSubcontroller, Storyboarded {

	// MARK: - Properties
	public var presenter: TemplateAlertAction!
    public weak var container: ContainerProtocol?
    
    var mainButtonType: SmallAlertMainButtonType = .light {
        didSet {
            handleMainButton(with: mainButtonType)
        }
    }

    // MARK: - Outlets
    @IBOutlet weak private var cardView: UIView!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var titleStackView: UIStackView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var buttonsStackView: UIStackView!
    @IBOutlet weak private var mainButton: VerticalRoundButton!
    @IBOutlet weak private var buttonsBottomConstraint: NSLayoutConstraint!
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.font = FontBook.bigEmoji
        label.isAccessibilityElement = false
        return label
    }()
    
    private lazy var alternativeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FontBook.bigText
        
        button.heightAnchor.constraint(equalToConstant: Constants.alternativeButtonHeight).isActive = true
        button.addTarget(self, action: #selector(alternativeButtonTapped), for: .touchUpInside)
        
        return button
    }()

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
    }
    
    private func initialSetup() {
        setupFonts()
        setupUI()
        handleMainButton(with: mainButtonType)
        setupButtons()
    }
    
    private func setupFonts() {
        titleLabel.font = FontBook.cardsHeadingFont
        descriptionLabel.font = FontBook.usualFont
        mainButton.titleLabel?.font = FontBook.smallHeadingFont
    }
    
    private func setupUI() {
        cardView.layer.cornerRadius = Constants.cardViewCornerRadius
        cardView.layer.masksToBounds = true
    }
    
    private func setupButtons() {
        mainButton.withBorder(width: Constants.mainButtonBorderWidth, color: .black)
        mainButton.contentEdgeInsets = Constants.buttonInsets
    }
    
    private func handleMainButton(with type: SmallAlertMainButtonType) {
        switch type {
        case .solid:
            mainButton?.backgroundColor = .black
            mainButton?.setTitleColor(.white, for: .normal)
            mainButton?.layer.borderColor = UIColor.black.cgColor
        case .light:
            mainButton?.backgroundColor = .clear
            mainButton?.setTitleColor(.black, for: .normal)
            mainButton?.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    // MARK: - Private Methods
    @IBAction private func closeButtonTapped() {
        presenter.close()
    }
    
    @IBAction private func mainButtonTapped() {
        presenter.onMainButton()
    }
    
    @objc private func alternativeButtonTapped() {
        presenter.onAlternativeButton()
    }
}

// MARK: - View logic
extension SmallAlertViewController: TemplateAlertView {
    public func configure(with viewModel: AlertViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        descriptionLabel.isHidden = viewModel.description.count == 0
        
        mainButton.setTitle(viewModel.mainButton.title, for: .normal)
        mainButton.setImage(viewModel.mainButton.image, for: .normal)
        mainButton.imageView?.contentMode = .scaleAspectFit
        
        closeButton.isHidden = !viewModel.isClosable
        
        if viewModel.hasIcon {
            iconLabel.text = viewModel.icon
            titleStackView.insertArrangedSubview(iconLabel, at: 0)
        }
        
        if viewModel.hasAlternativeButton {
            alternativeButton.setTitle(viewModel.alternativeButton?.title, for: .normal)
            alternativeButton.setImage(viewModel.alternativeButton?.image, for: .normal)
            buttonsStackView.addArrangedSubview(alternativeButton)
        }
        
        buttonsBottomConstraint.constant = viewModel.hasAlternativeButton
            ? Constants.bottomInsetWithAlternative
            : Constants.bottomInsetNoAlternative
        
    }
    
    public func close() {
        container?.close()
    }
}

// MARK: - Constants
extension SmallAlertViewController {
    private enum Constants {
        static let cardViewCornerRadius: CGFloat = 16
        static let mainButtonBorderWidth: CGFloat = 2
        static let alternativeButtonHeight: CGFloat = 48
        static let buttonInsets = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 40)
        static let bottomInsetWithAlternative: CGFloat = 16
        static let bottomInsetNoAlternative: CGFloat = 40
    }
}
