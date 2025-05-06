
import UIKit
import DiiaMVPModule
import DiiaCommonTypes

public final class AddressSearchModule: BaseModule {
    private let view: AddressSearchViewController
    private let presenter: AddressSearchPresenter
    
    public init(handler: AddressSearchHandlerProtocol,
                contextMenuProvider: ContextMenuProviderProtocol,
                networkingContext: NetworkingContext) {
        view = AddressSearchViewController()
        presenter = AddressSearchPresenter(view: view,
                                           handler: handler,
                                           contextMenuProvider: contextMenuProvider,
                                           networkingContext: networkingContext)
        view.presenter = presenter
    }

    public func viewController() -> UIViewController {
        return view
    }
}
