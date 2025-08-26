
import DiiaCommonTypes

public struct TemplateHandlerContext {
    
    internal let router: RoutingHandlerProtocol?
    internal let deepLinkManager: DeepLinkManagerProtocol
    internal let communicationHelper: URLOpenerProtocol
    
    public init(router: RoutingHandlerProtocol, deepLink: DeepLinkManagerProtocol, communicationHelper: URLOpenerProtocol) {
        self.router = router
        self.deepLinkManager = deepLink
        self.communicationHelper = communicationHelper
    }
}
