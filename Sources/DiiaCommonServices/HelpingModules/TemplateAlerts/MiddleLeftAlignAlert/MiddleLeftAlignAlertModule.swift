import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

final class MiddleLeftAlignAlertModule: BaseModule {
    private let view: MiddleLeftAlignAlertViewController
    private let presenter: TemplateAlertPresenter
    
    init(viewModel: AlertViewModel,
         callback: @escaping (AlertTemplateAction) -> Void,
         onClose: @escaping Callback) {
        view = MiddleLeftAlignAlertViewController.storyboardInstantiate(bundle: Bundle.module)
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
