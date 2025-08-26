
import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

protocol SingleSelectionView: BaseView {
    func update()
}

final class SingleSelectionViewController: UIViewController {
    // MARK: - Properties
    var presenter: SingleSelectionPresenterInterface!

    @IBOutlet private weak var searchTF: UITextField!
    @IBOutlet private weak var searchContainer: UIView!
    @IBOutlet private weak var topView: TopNavigationView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyView: StubMessageViewV2!

	// MARK: - Init
    init() {
        super.init(nibName: SingleSelectionViewController.className, bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter.configureView()
    }

    // MARK: - Private -
    private func updateEmptyViewVisibility() {
        emptyView.isHidden = presenter.numberOfItems != 0
    }

    private func cellPosition(at indexPath: IndexPath) -> SingleSelectionCellModel.Position {
        let numberOfItems = presenter.numberOfItems

        guard numberOfItems != 1 else { return .single }

        if indexPath.row == 0 {
            return .first
        } else if indexPath.row == numberOfItems - 1 {
            return .last
        } else {
            return .middle
        }
    }

    // MARK: - Configuration
    private func setup() {
        view.accessibilityIdentifier = presenter.componentId

        setupTopView()
        setupEmptyView()
        setupTableView()
        setupSearchField()
    }
    
    private func setupTopView() {
        topView.setupTitle(title: presenter.headerTitle)
        topView.setupOnContext(callback: nil)
        topView.setupOnClose(callback: { [weak self] in
            self?.closeModule(animated: true)
        })
    }
    
    private func setupTableView() {
        tableView.register(SingleSelectionCell.self, forCellReuseIdentifier: SingleSelectionCell.reuseID)
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupEmptyView() {
        emptyView.configure(with: StubMessageViewModel(model: Constants.emptyStub))
    }

    private func setupSearchField() {
        searchContainer.layer.cornerRadius = 16
        searchTF.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        searchTF.placeholder = presenter.placeholder
        searchTF.clearButtonMode = .whileEditing
    }
    
    @objc private func textChanged() {
        presenter.searchTextUpdated(searchTF.text ?? .empty)
    }
}

// MARK: - SingleSelectionViewController + SingleSelectionView
extension SingleSelectionViewController: SingleSelectionView {
    func update() {
        tableView.reloadData()
        updateEmptyViewVisibility()
    }
}

// MARK: - SingleSelectionViewController + RatingFormHolder
extension SingleSelectionViewController: RatingFormHolder {
    func screenCode() -> String {
        return Constants.screenCode
    }
}

// MARK: - SingleSelectionViewController + UITableViewDelegate + UITableViewDataSource
extension SingleSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = presenter.item(at: indexPath.row) else { return UITableViewCell() }

        if let cell = tableView.dequeueReusableCell(withIdentifier: SingleSelectionCell.reuseID, for: indexPath) as? SingleSelectionCell {
            let position = cellPosition(at: indexPath)

            let model = SingleSelectionCellModel(
                title: item.title,
                additionalText: item.additionalText,
                position: position
            )

            cell.configure(model: model)
            
            cell.setEnabled(isEnabled: item.isEnabled)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.itemSelected(at: indexPath.row)
    }
}

// MARK: - SingleSelectionViewController + Constants
extension SingleSelectionViewController {
    enum Constants {
        static let screenCode = ""
        static let emptyStub = DSStubMessageMlc(
            icon: "🤷‍♂️",
            title: R.Strings.single_selection_empty_results_title.localized(),
            description: R.Strings.single_selection_empty_results_subtitle.localized(),
            componentId: nil,
            parameters: nil,
            btnStrokeAdditionalAtm: nil
        )
    }
}
