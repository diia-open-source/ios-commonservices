import UIKit
import DiiaCommonTypes
import DiiaMVPModule

public protocol BaseSearchAction: BasePresenter {
    func numberOfItems() -> Int
    func itemAt(index: Int) -> String?
    func setSearchText(text: String)
    func selectItem(index: Int)
}

final class BaseSearchPresenter: BaseSearchAction {
    unowned var view: BaseSearchView

    private var callback: (SearchModel) -> Void
    private var items: [SearchModel] = []
    private var allItems: [SearchModel] = []
    private var keyword: String = ""

    init(view: BaseSearchView, items: [SearchModel], callback: @escaping (SearchModel) -> Void) {
        self.view = view
        self.callback = callback
        self.allItems = items
    }
    
    func configureView() {
        setSearchText(text: "")
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func itemAt(index: Int) -> String? {
        if index < items.count && index >= 0 {
            return items[index].title
        }
        return nil
    }
    
    func setSearchText(text: String) {
        if text.count == 0 {
            items = allItems
            view.update()
            return
        }
        keyword = text.lowercased()
        var newItems: [(Int, SearchModel)] = []
        for item in allItems {
            if let range = item.title.lowercased().range(of: keyword) {
                newItems.append((range.lowerBound.encodedOffset, item))
            }
        }
        items = newItems.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
        view.update()
    }
    
    func selectItem(index: Int) {
        if index < items.count && index >= 0 {
            callback(items[index])
        }
        view.closeModule(animated: true)
    }
}
