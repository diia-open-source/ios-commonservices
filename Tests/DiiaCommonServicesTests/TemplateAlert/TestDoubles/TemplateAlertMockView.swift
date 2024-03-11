import UIKit
@testable import DiiaCommonServices

class TemplateAlertMockView: UIViewController, TemplateAlertView {
    private(set) var isViewConfigured: Bool = false
    private(set) var isCloseCalled: Bool = false
    
    func configure(with viewModel: AlertViewModel) {
        isViewConfigured.toggle()
    }
    
    func close() {
        isCloseCalled.toggle()
    }
}
