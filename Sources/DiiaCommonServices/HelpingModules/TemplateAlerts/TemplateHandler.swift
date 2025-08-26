
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
            state = .default
            handleAction(
                action: action,
                resource: actionButtonWithAction(action: action, in: template)?.resource,
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
        case .middleCenterIconBlackButtonAlert:
            module = IconAlertModule(
                viewModel: viewModel,
                callback: callbackWithGlobalActions,
                onClose: { state = .default })
        }
                
        view.showChild(module: module)
        state = .showing
    }
    
    public static func handleGlobal(_ template: AlertTemplate,
                                    callback: @escaping (AlertTemplateAction) -> Void) {
        let viewModel = AlertViewModel(template: template)
        
        let module: BaseModule
        
        let commonCallback: (AlertTemplateAction) -> Void = { action in
            state = .default
            callback(action)
        }
        
        switch template.type {
        case .middleLeftAlignAlert:
            module = MiddleLeftAlignAlertModule(
                viewModel: viewModel,
                callback: commonCallback,
                onClose: { state = .default }
            )
        case .largeAlert:
            module = LargeAlertModule(
                viewModel: viewModel,
                callback: commonCallback,
                onClose: { state = .default }
            )
        case .smallAlert, .middleCenterAlignAlert:
            module = SmallAlertModule(
                viewModel: viewModel,
                callback: commonCallback,
                onClose: { state = .default }
            )
        case .middleCenterBlackButtonAlert:
            module = SmallAlertModule(
                viewModel: viewModel,
                callback: commonCallback,
                onClose: { state = .default },
                mainButtonType: .solid
            )
        case .middleCenterIconBlackButtonAlert:
            module = IconAlertModule(
                viewModel: viewModel,
                callback: commonCallback,
                onClose: { state = .default })
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
    
    private static func handleAction(action: AlertTemplateAction, resource: String?, genericCallback: (AlertTemplateAction) -> Void) {
        switch action {
        case .internalLink:
            guard let resource = resource, let url = URL(string: resource) else { return }
            _ = deepLinkManager?.parse(url: url)
        case .externalLink:
            guard let resource = resource else { return }
            _ = communicationHelper?.url(urlString: resource, linkType: nil)
        case .vehicleExternalLink:
            guard let resource = resource else { return }
            _ = communicationHelper?.url(urlString: resource, linkType: nil)
        case .publicServices:
            router?.popToPublicServices()
        case .feed:
            router?.popToFeed()
        case .documents:
            router?.popToDocuments()
        default:
            break
        }
        genericCallback(action)
    }
}
