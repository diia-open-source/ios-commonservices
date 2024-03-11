import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents
       
public class BaseSearchModule: BaseModule {
    private let view: BaseSearchViewController
    private let presenter: BaseSearchPresenter
    
    public init(items: [SearchModel], callback: @escaping (SearchModel) -> Void) {
        view = BaseSearchViewController.storyboardInstantiate(bundle: Bundle.module)
        presenter = BaseSearchPresenter(view: view, items: items, callback: callback)
        view.presenter = presenter
    }

    public func viewController() -> UIViewController {
        return view
    }
}
