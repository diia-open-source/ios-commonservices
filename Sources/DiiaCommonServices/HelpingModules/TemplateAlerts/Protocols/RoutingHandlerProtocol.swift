
import Foundation
import DiiaMVPModule

public protocol RoutingHandlerProtocol {
    func performPresenting(action: @escaping (BaseView?) -> Void)
    func popToPublicServices()
    func popToFeed()
    func popToDocuments()
}

public protocol DeepLinkManagerProtocol {
    func parse(url: URL) -> Bool
}
