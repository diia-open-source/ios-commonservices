
import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

public final class SingleSelectionModule: BaseModule {
    private let view: SingleSelectionViewController
    private let presenter: SingleSelectionPresenter
    
    public init(configuration: SingleSelectionModuleConfiguration,
                callback: @escaping (SearchItemModel) -> Void) {
        view = SingleSelectionViewController()
        presenter = SingleSelectionPresenter(
            view: view,
            configuration: configuration,
            callback: callback)
        view.presenter = presenter
    }

    public convenience init(headerTitle: String? = nil,
                            items: [SearchItemModel],
                            callback: @escaping (SearchItemModel) -> Void) {
        let configuration = SingleSelectionModuleConfiguration(headerTitle: headerTitle, items: items)
        self.init(configuration: configuration, callback: callback)
    }

    public func viewController() -> UIViewController {
        return view
    }
}
