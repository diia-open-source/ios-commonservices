
import UIKit
import DiiaCommonTypes
@testable import DiiaCommonServices

final class SingleSelectionMockView: UIViewController, SingleSelectionView {
    private(set) var isViewUpdateCalled: Bool = false
    private(set) var isCloseModuleCalled: Bool = false
    private(set) var isSetupHeaderCalled: Bool = false

    func update() {
        isViewUpdateCalled = true
    }
    
    func closeModule(animated: Bool) {
        isCloseModuleCalled.toggle()
    }

    func setupHeader(contextMenuProvider: ContextMenuProviderProtocol?) {
        isSetupHeaderCalled = true
    }
}
