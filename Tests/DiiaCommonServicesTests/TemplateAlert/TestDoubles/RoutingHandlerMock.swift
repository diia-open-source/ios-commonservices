import UIKit
import DiiaMVPModule
@testable import DiiaCommonServices

class RoutingHandlerMock: RoutingHandlerProtocol {
    
    private(set) var isPerformOrDeferCalled: Bool = false

    func performPresenting(action: @escaping (BaseView?) -> Void) {
        isPerformOrDeferCalled.toggle()
    }
    
    func popToPublicServices() {
        
    }
    
    func popToFeed() {
        
    }
    
    func popToDocuments() {
        
    }
}
