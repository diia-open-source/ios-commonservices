import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

enum TemplateHandlerState {
    case `default`
    case showing
    case showingGlobal
}

public class TemplateHandler {
    
    // MARK: - Properties
    private static var router: RoutingHandlerProtocol?
    private static var deepLinkManager: DeepLinkManagerProtocol?
    private static var communicationHelper: URLOpenerProtocol?

    private static var state: TemplateHandlerState = .default
    
    // MARK: - Public Methods
    public static func setup(context: TemplateHandlerContext) {
        TemplateHandler.router = context.router
        TemplateHandler.deepLinkManager = context.deepLinkManager
        TemplateHandler.communicationHelper = context.communicationHelper
    }
    
    public static func handle(
        _ template: AlertTemplate,
        in view: BaseView,
        callback: @escaping (AlertTemplateAction) -> Void,
        onClose: Callback? = nil
    ) {
        guard state != .showingGlobal else { return }
        
        let viewModel = AlertViewModel(template: template)
        
        let module: BaseModule
        
        let callbackWithGlobalActions: (AlertTemplateAction) -> Void = { action in
            handleAction(
                action: action,
                link: actionButtonWithAction(action: action, in: template)?.link,
                genericCallback: callback)
        }
        
        switch template.type {
        case .middleLeftAlignAlert:
            module = MiddleLeftAlignAlertModule(
                viewModel: viewModel,
                callback: callbackWithGlobalActions,
                onClose: {
                    onClose?()
                    state = .default
                }
            )
        case .largeAlert:
            module = LargeAlertModule(
                viewModel: viewModel,
                callback: callbackWithGlobalActions,
                onClose: {
                    onClose?()
                    state = .default
                }
            )
        case .smallAlert, .middleCenterAlignAlert:
            module = SmallAlertModule(
                viewModel: viewModel,
                callback: callbackWithGlobalActions,
                onClose: {
                    onClose?()
                    state = .default
                }
            )
        case .middleCenterBlackButtonAlert:
            module = SmallAlertModule(
                viewModel: viewModel,
                callback: callbackWithGlobalActions,
                onClose: {
                    onClose?()
                    state = .default
                },
                mainButtonType: .solid
            )
        }
                
        view.showChild(module: module)
        state = .showing
    }
    
    public static func handleGlobal(_ template: AlertTemplate,
                                    callback: @escaping (AlertTemplateAction) -> Void) {
        let viewModel = AlertViewModel(template: template)
        
        let module: BaseModule
        
        switch template.type {
        case .middleLeftAlignAlert:
            module = MiddleLeftAlignAlertModule(
                viewModel: viewModel,
                callback: callback,
                onClose: { state = .default }
            )
        case .largeAlert:
            module = LargeAlertModule(
                viewModel: viewModel,
                callback: callback,
                onClose: { state = .default }
            )
        case .smallAlert, .middleCenterAlignAlert:
            module = SmallAlertModule(
                viewModel: viewModel,
                callback: callback,
                onClose: { state = .default }
            )
        case .middleCenterBlackButtonAlert:
            module = SmallAlertModule(
                viewModel: viewModel,
                callback: callback,
                onClose: { state = .default },
                mainButtonType: .solid
            )
        }
        
        let alertController = module.viewController()
        
        router?.performPresenting { (view) in
            view?.showChild(module: module)
            LoadingView.globalLoadingView?.superview?.isUserInteractionEnabled = true
            alertController.view.toFront()
            TemplateHandler.state = .showingGlobal
        }
    }
    
    // MARK: - Private
    private static func actionButtonWithAction(action: AlertTemplateAction, in template: AlertTemplate) -> AlertButtonModel? {
        let buttons = [template.data.mainButton, template.data.alternativeButton]
            .compactMap { $0 }
        return buttons.first(where: { $0.action == action })
    }
    
    private static func handleAction(action: AlertTemplateAction, link: String?, genericCallback: (AlertTemplateAction) -> Void) {
        switch action {
        case .internalLink:
            guard let link = link, let url = URL(string: link) else { return }
            _ = deepLinkManager?.parse(url: url)
        case .externalLink:
            guard let link = link else { return }
            _ = communicationHelper?.url(urlString: link, linkType: nil)
        case .vehicleExternalLink:
            genericCallback(action)
            guard let link = link else { return }
            _ = communicationHelper?.url(urlString: link, linkType: nil)
        case .publicServices:
            router?.popToPublicServices()
        default:
            genericCallback(action)
        }
    }
}
