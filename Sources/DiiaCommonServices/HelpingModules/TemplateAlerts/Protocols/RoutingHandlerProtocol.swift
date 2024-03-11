import UIKit
import DiiaMVPModule

public protocol RoutingHandlerProtocol {
    func performPresenting(action: @escaping (BaseView?) -> Void)
    func popToPublicServices()
}

public protocol DeepLinkManagerProtocol {
    func parse(url: URL) -> Bool
}
