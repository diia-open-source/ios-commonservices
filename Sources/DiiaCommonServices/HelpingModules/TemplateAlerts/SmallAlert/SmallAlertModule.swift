
import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

enum SmallAlertMainButtonType {
    case solid
    case light
}

final class SmallAlertModule: BaseModule {
    private let view: SmallAlertViewController
    private let presenter: TemplateAlertPresenter
    
    init(
        viewModel: AlertViewModel,
        callback: @escaping (AlertTemplateAction) -> Void,
        onClose: @escaping Callback,
        mainButtonType: SmallAlertMainButtonType = .light
    ) {
        view = SmallAlertViewController.storyboardInstantiate(bundle: Bundle.module)
        presenter = TemplateAlertPresenter(view: view, viewModel: viewModel, callback: callback, onClose: onClose)
        view.presenter = presenter
        view.mainButtonType = mainButtonType
    }

    func viewController() -> UIViewController {
        let vc = ChildContainerViewController()
        vc.childSubview = view
        vc.presentationStyle = .fullscreen
        return vc
    }
}
