
import UIKit
import DiiaUIComponents
import DiiaMVPModule
import DiiaCommonTypes

protocol IconAlertView: BaseView {
    func setupHeader(contextMenuProvider: ContextMenuProviderProtocol)
    func setLoadingState(_ state: LoadingState)
}

final class IconAlertViewController: UIViewController, ChildSubcontroller {

    // MARK: - Properties
    
    private let iconView = UIImageView().withSize(Constants.imageSize)
    private let titleLabel = UILabel().withParameters(font: FontBook.cardsHeadingFont, textAlignment: .center)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont, textAlignment: .center)
    private let mainButton = LoadingStateButton()
    private let altButton = LoadingStateButton()
    
    var presenter: TemplateAlertAction!
    weak var container: ContainerProtocol?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupAccessibility()
        presenter.configureView()
    }
    
    private func setupSubviews() {
        self.view.backgroundColor = .clear
        
        self.mainButton.setStyle(style: .solid)
        self.altButton.setStyle(style: .light)
        
        let containerView = UIView()
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: .allSides(Constants.defaultPadding))
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let topStackView = UIStackView.create(
            views: [iconView, titleLabel, descriptionLabel],
            spacing: Constants.defaultPadding,
            alignment: .center)
        
        containerView.addSubview(topStackView)
        topStackView.anchor(top: containerView.topAnchor,
                         leading: containerView.leadingAnchor,
                         trailing: containerView.trailingAnchor,
                            padding: .allSides(Constants.textPadding))
        
        let buttonStack = UIStackView.create(views: [mainButton, altButton],
                                             spacing: Constants.buttonSpacing,
                                             distribution: .fillEqually)
        mainButton.withHeight(Constants.buttonSize)
        
        containerView.addSubview(buttonStack)
        buttonStack.anchor(top: topStackView.bottomAnchor,
                           leading: containerView.leadingAnchor,
                           bottom: containerView.bottomAnchor,
                           trailing: containerView.trailingAnchor,
                           padding: Constants.buttonInsets)
        
        mainButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        altButton.addTarget(self, action: #selector(altActionTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func closeTapped() {
        presenter.close()
    }
    
    @objc private func actionTapped() {
        presenter.onMainButton()
    }
    
    @objc private func altActionTapped() {
        presenter.onAlternativeButton()
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = .staticText
        
        descriptionLabel.isAccessibilityElement = true
        descriptionLabel.accessibilityTraits = .staticText
        
        mainButton.isAccessibilityElement = true
        mainButton.accessibilityTraits = .button
        
        altButton.isAccessibilityElement = true
        altButton.accessibilityTraits = .button
        
        UIAccessibility.post(notification: .screenChanged, argument: titleLabel)
    }
}

// MARK: - View logic
extension IconAlertViewController: TemplateAlertView {
    func configure(with viewModel: AlertViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        descriptionLabel.isHidden = viewModel.description.count == 0
        
        mainButton.setLoadingState(.enabled, withTitle: viewModel.mainButton.title ?? "")

        iconView.image = UIImage(named: viewModel.icon ?? .empty, in: Bundle.module, compatibleWith: .none)
        iconView.isHidden = viewModel.icon == nil
        
        altButton.isHidden = !viewModel.hasAlternativeButton
        if viewModel.hasAlternativeButton {
            altButton.setLoadingState(.enabled, withTitle: viewModel.alternativeButton?.title ?? "")
        }
        if viewModel.isClosable {
            let viewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
            view.addGestureRecognizer(viewGestureRecognizer)
        }
        altButton.titleLabel?.font = Constants.fontSize
        mainButton.titleLabel?.font = Constants.fontSize
        
        titleLabel.accessibilityLabel = viewModel.title
        descriptionLabel.accessibilityLabel = viewModel.description
        mainButton.accessibilityLabel = viewModel.mainButton.title
        altButton.accessibilityLabel = viewModel.alternativeButton?.title
    }
    
    func close() {
        container?.close()
    }
}

// MARK: - Constants
extension IconAlertViewController {
    private enum Constants {
        static let fontSize = FontBook.mainFont.regular.size(16)
        static let buttonSize: CGFloat = 56
        static let defaultPadding: CGFloat = 16
        static let textPadding: CGFloat = 32
        static let cornerRadius: CGFloat = 24
        static let buttonSpacing: CGFloat = 8
        static let buttonInsets = UIEdgeInsets(top: 32, left: 40, bottom: 32, right: 40)
        static let imageSize = CGSize(width: 48, height: 48)
    }
}
