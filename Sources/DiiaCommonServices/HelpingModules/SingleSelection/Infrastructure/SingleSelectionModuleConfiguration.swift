
import DiiaCommonTypes

public struct SingleSelectionModuleConfiguration {
    public let headerTitle: String?
    public let placeholder: String?
    public let componentId: String?
    public let items: [SearchItemModel]
    public let sorter: SearchItemsSorter

    public init(
        headerTitle: String?,
        items: [SearchItemModel],
        sorter: SearchItemsSorter = BaseSearchItemsSorter.byDefault,
        placeholder: String? = nil,
        componentId: String? = nil
    ) {
        self.headerTitle = headerTitle
        self.placeholder = placeholder
        self.componentId = componentId
        self.items = items
        self.sorter = sorter
    }
}
