import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

public class ContactsInputModule: BaseModule {
    private let view: ContactsInputViewController
    private let presenter: ContactsInputPresenter

    public init(contextMenuProvider: ContextMenuProviderProtocol,
                contactsHandler: ContactsInputHandler,
                stepCounter: StepCounter? = nil,
                urlOpener: URLOpenerProtocol? = nil) {
        view = ContactsInputViewController()
        presenter = ContactsInputPresenter(view: view,
                                           contextMenuProvider: contextMenuProvider,
                                           contactsHandler: contactsHandler,
                                           stepCounter: stepCounter,
                                           urlOpener: urlOpener)
        view.presenter = presenter
    }

    public func viewController() -> UIViewController {
        return view
    }
}
