
import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

protocol SingleSelectionPresenterInterface: BasePresenter {
    var numberOfItems: Int { get }
    var headerTitle: String { get }
    var placeholder: String { get }
    var componentId: String { get }

    func itemSelected(at index: Int)
    func searchTextUpdated(_ text: String)
    func item(at index: Int) -> SearchItemModel?
}

final class SingleSelectionPresenter: SingleSelectionPresenterInterface {
    // MARK: - Properties
    unowned var view: SingleSelectionView

    var numberOfItems: Int {
        return filteredItems.count
    }

    var headerTitle: String {
        return configuration.headerTitle ?? R.Strings.single_selection_default_title.localized()
    }

    var placeholder: String {
        return configuration.placeholder ?? R.Strings.single_selection_default_placeholder.localized()
    }

    var componentId: String {
        return configuration.componentId ?? .empty
    }

    private var callback: (SearchItemModel) -> Void
    private var filteredItems: [SearchItemModel] = []

    private let configuration: SingleSelectionModuleConfiguration

    // MARK: - Init
    init(view: SingleSelectionView,
         configuration: SingleSelectionModuleConfiguration,
         callback: @escaping (SearchItemModel) -> Void) {
        self.view = view
        self.configuration = configuration
        self.callback = callback
    }

    // MARK: - Public
    func configureView() {
        searchTextUpdated(.empty)
    }

    func item(at index: Int) -> SearchItemModel? {
        return filteredItems[safe: index]
    }
    
    func searchTextUpdated(_ text: String) {
        filteredItems = configuration.sorter.sort(by: text, in: configuration.items)
        view.update()
    }

    func itemSelected(at index: Int) {
        guard let selectedItem = filteredItems[safe: index],
              selectedItem.isEnabled else { return }
        callback(filteredItems[index])

        view.closeModule(animated: true)
    }
}
