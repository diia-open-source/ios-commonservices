import UIKit
@testable import DiiaCommonServices

class BaseSearchMockView: UIViewController, BaseSearchView {
    private(set) var isViewUpdateCalled: Bool = false
    private(set) var isCloseModuleCalled: Bool = false
    
    func update() {
        isViewUpdateCalled = true
    }
    
    func closeModule(animated: Bool) {
        isCloseModuleCalled.toggle()
    }
}
