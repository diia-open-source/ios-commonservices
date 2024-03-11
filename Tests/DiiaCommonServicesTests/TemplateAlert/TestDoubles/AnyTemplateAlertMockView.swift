import UIKit
import DiiaMVPModule
import DiiaUIComponents
@testable import DiiaCommonServices

protocol AnyTemplateAlertView {
    var presenter: TemplateAlertAction! { get set }
}

class AnyTemplateAlertMockView: UIViewController, BaseView {
    var onTemplateShow: ((Bool) -> Void)?
    
    func showChild(module: BaseModule) {
        if let childContainerController = module.viewController() as? ChildContainerViewController {
            if let controller = childContainerController.childSubview as? AnyTemplateAlertView {
                onTemplateShow?(true)
                controller.presenter.onMainButton()
            }
        }
    }
}

extension SmallAlertViewController: AnyTemplateAlertView {}
extension LargeAlertViewController: AnyTemplateAlertView {}
extension MiddleLeftAlignAlertViewController: AnyTemplateAlertView {}
