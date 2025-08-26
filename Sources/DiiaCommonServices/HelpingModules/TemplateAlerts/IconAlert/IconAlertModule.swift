
import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

final class IconAlertModule: BaseModule {
    private let view: IconAlertViewController
    private let presenter: TemplateAlertPresenter
    
    init(viewModel: AlertViewModel,
         callback: @escaping (AlertTemplateAction) -> Void,
         onClose: @escaping Callback) {
        view = IconAlertViewController()
        presenter = TemplateAlertPresenter(view: view, viewModel: viewModel, callback: callback, onClose: onClose)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        let vc = ChildContainerViewController()
        vc.childSubview = view
        vc.presentationStyle = .fullscreen
        return vc
    }
}
