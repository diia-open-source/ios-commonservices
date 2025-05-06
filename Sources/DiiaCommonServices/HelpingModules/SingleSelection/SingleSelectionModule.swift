
import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

public final class SingleSelectionModule: BaseModule {
    private let view: SingleSelectionViewController
    private let presenter: SingleSelectionPresenter
    
    public init(configuration: SingleSelectionModuleConfiguration,
                contextMenuProvider: ContextMenuProviderProtocol? = nil,
                callback: @escaping (SearchItemModel) -> Void) {
        view = SingleSelectionViewController()
        presenter = SingleSelectionPresenter(
            view: view,
            configuration: configuration,
            contextMenuProvider: contextMenuProvider,
            callback: callback)
        view.presenter = presenter
    }

    public convenience init(headerTitle: String? = nil,
                            items: [SearchItemModel],
                            contextMenuProvider: ContextMenuProviderProtocol? = nil,
                            callback: @escaping (SearchItemModel) -> Void) {
        let configuration = SingleSelectionModuleConfiguration(headerTitle: headerTitle, items: items)
        self.init(configuration: configuration, contextMenuProvider: contextMenuProvider, callback: callback)
    }

    public func viewController() -> UIViewController {
        return view
    }
}
