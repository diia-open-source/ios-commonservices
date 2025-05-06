
import DiiaCommonTypes

public protocol SearchItemsSorter {
    func sort<T: SearchableItemModel>(by keyword: String, in items: [T]) -> [T]
}
