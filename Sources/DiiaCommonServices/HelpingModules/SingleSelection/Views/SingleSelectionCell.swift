
import UIKit
import DiiaUIComponents

struct SingleSelectionCellModel {
    enum Position {
        case first
        case middle
        case last
        case single
    }

    let title: String
    let additionalText: String?
    let position: Position
}

final class SingleSelectionCell: BaseTableNibCell {
    // MARK: - Properties
    private let titleLabel = UILabel().withParameters(
        font: FontBook.bigText,
        lineBreakMode: .byTruncatingTail
    )

    private let additionalLabel = UILabel().withParameters(
        font: FontBook.usualFont,
        textColor: .statusGray,
        lineBreakMode: .byTruncatingTail
    )

    private let divider = UIView()

    private lazy var mainStackView: UIStackView = .create(
        views: [titleLabel, additionalLabel],
        spacing: Constants.labelsSpacing,
        distribution: .fillProportionally
    )

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func configure(model: SingleSelectionCellModel) {
        titleLabel.text = model.title
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        if let additionalText = model.additionalText {
            additionalLabel.text = additionalText
        }

        additionalLabel.isHidden = model.additionalText == nil
        additionalLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        divider.isHidden = false
        layer.cornerRadius = Constants.cornerRadius

        switch model.position {
        case .first:
            layer.maskedCorners = .topCorners
        case .middle:
            layer.cornerRadius = .zero
        case .last:
            layer.maskedCorners = .bottomCorners
            divider.isHidden = true
        case .single:
            layer.maskedCorners = .allCorners
            divider.isHidden = true
        }
    }

    func setEnabled(isEnabled: Bool) {
        titleLabel.alpha = isEnabled ? 1 : 0.3
        additionalLabel.alpha = isEnabled ? 1 : 0.3
    }

    // MARK: - Private -
    private func setup() {
        clipsToBounds = true

        setupMainStackView()
        setupDivider()
    }

    private func setupMainStackView() {
        contentView.addSubview(mainStackView)

        mainStackView
            .fillSuperview(padding: UIEdgeInsets(
                    top: Constants.innerPadding,
                    left: Constants.innerPadding,
                    bottom: Constants.innerPadding,
                    right: Constants.innerPadding
                )
            )
    }

    private func setupDivider() {
        divider.backgroundColor = UIColor("#E2ECF4")

        addSubview(divider)

        divider
            .anchor(
                top: nil,
                leading: leadingAnchor,
                bottom: bottomAnchor,
                trailing: trailingAnchor,
                size: CGSize(width: .zero, height: Constants.dividerHeight)
            )
    }
}

// MARK: - SingleSelectionCell + Constants
private extension SingleSelectionCell {
    enum Constants {
        static let innerPadding: CGFloat = 16.0
        static let dividerHeight: CGFloat = 1.0
        static let cornerRadius: CGFloat = 16.0
        static let labelsSpacing: CGFloat = 4.0
    }
}
