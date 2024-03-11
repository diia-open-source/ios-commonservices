import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol BaseSearchView: BaseView {
    func update()
}

public final class BaseSearchViewController: UIViewController, Storyboarded {

	// MARK: - Properties
	public var presenter: BaseSearchAction!

    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        presenter.configureView()
    }
    
    // MARK: - Configuration
    private func setupTableView() {        
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @IBAction private func backBtnPressed(_ sender: Any) {
        self.closeModule(animated: true)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - View logic
extension BaseSearchViewController: BaseSearchView {
    func update() {
        tableView.reloadData()
    }
}

// MARK: - Table View Methods
extension BaseSearchViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let title = presenter.itemAt(index: indexPath.row) else { return UITableViewCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableCell.reuseID, for: indexPath) as? SearchTableCell {
            cell.setTitle(title: title)
            return cell
        }
        
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectItem(index: indexPath.row)
    }
}

// MARK: - SearchBar Methods
extension BaseSearchViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.setSearchText(text: searchText)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
}
