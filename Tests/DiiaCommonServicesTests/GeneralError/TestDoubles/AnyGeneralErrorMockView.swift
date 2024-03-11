import UIKit
import DiiaMVPModule
@testable import DiiaCommonServices

class AnyGeneralErrorMockView: UIViewController, BaseView {
    var onGeneralErrorShow: ((Bool) -> Void)?
    
    func showChild(module: BaseModule) {
        if module is GeneralErrorModule {
            onGeneralErrorShow?(true)
        }
    }
}
