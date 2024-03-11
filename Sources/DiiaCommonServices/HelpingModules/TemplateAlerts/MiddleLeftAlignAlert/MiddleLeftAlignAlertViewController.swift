import UIKit
import DiiaUIComponents

final class MiddleLeftAlignAlertViewController: UIViewController, ChildSubcontroller, Storyboarded {

    // MARK: - Properties
    var presenter: TemplateAlertAction!
    weak var container: ContainerProtocol?

    // MARK: - Outlets
    @IBOutlet weak private var cardView: UIView!
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
        button.titleLabel?.font = FontBook.smallHeadingFont
        
        button.heightAnchor.constraint(equalToConstant: Constants.alternativeButtonHeight).isActive = true
        button.addTarget(self, action: #selector(alternativeButtonTapped), for: .touchUpInside)
        
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
    }
    
    private func initialSetup() {
        setupFonts()
        setupUI()
        setupButtons()
    }
    
    private func setupFonts() {
        titleLabel.font = FontBook.cardsHeadingFont
        descriptionLabel.font = FontBook.usualFont
        mainButton.titleLabel?.font = FontBook.bigText
    }
    
    private func setupUI() {
        cardView.layer.cornerRadius = Constants.cardViewCornerRadius
        cardView.layer.masksToBounds = true
    }
    
    private func setupButtons() {
        mainButton.contentEdgeInsets = Constants.buttonInsets
    }
    
    // MARK: - Private Methods
    @IBAction private func mainButtonTapped() {
        presenter.onMainButton()
    }
    
    @objc private func alternativeButtonTapped() {
        presenter.onAlternativeButton()
    }
}

// MARK: - View logic
extension MiddleLeftAlignAlertViewController: TemplateAlertView {
    func configure(with viewModel: AlertViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        descriptionLabel.isHidden = viewModel.description.count == 0
        mainButton.setTitle(viewModel.mainButton.title, for: .normal)
        mainButton.setImage(viewModel.mainButton.image, for: .normal)
        mainButton.imageView?.contentMode = .scaleAspectFit

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
    
    func close() {
        container?.close()
    }
}

// MARK: - Constants
extension MiddleLeftAlignAlertViewController {
    private enum Constants {
        static let cardViewCornerRadius: CGFloat = 16
        static let mainButtonBorderWidth: CGFloat = 2
        static let alternativeButtonHeight: CGFloat = 48
        static let buttonInsets = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 40)
        static let bottomInsetWithAlternative: CGFloat = 16
        static let bottomInsetNoAlternative: CGFloat = 40
    }
}
