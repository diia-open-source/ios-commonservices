import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

public struct GeneralErrorsHandler {
    
    /// Processing of error with module closing on close button
    /// or action button after retry
    public static func process(error: GeneralError,
                               with retryAction: @escaping Callback,
                               didRetry: Bool,
                               in view: BaseView,
                               notClosable: Bool = false) {
        let closeAction: Callback = { [weak view] in view?.closeModule(animated: true) }
        
        let viewModel = GeneralErrorViewModel(
            error: error,
            isRetryAllowed: !didRetry,
            buttonAction: didRetry ? closeAction : retryAction,
            closeAction: closeAction,
            notClosable: notClosable
        )
        
        showError(with: viewModel, in: view)
    }
    
    /// Processing of error without retrying.
    /// Force close used to show error with
    /// one action - current module closing.
    /// If force close is false, only error is closed
    public static func process(error: GeneralError,
                               in view: BaseView,
                               forceClose: Bool = false) {
        let closeAction: Callback = { [weak view] in view?.closeModule(animated: true) }
        
        let viewModel = GeneralErrorViewModel(
            error: error,
            isRetryAllowed: false,
            buttonAction: forceClose ? closeAction : { },
            closeAction: forceClose ? nil : { }
        )
        
        showError(with: viewModel, in: view)
    }

    public static func process(error: GeneralError,
                               in view: BaseView?,
                               forceClose: Bool) {
        guard let view = view else {
            return
        }
        let closeAction: Callback = { [weak view] in view?.closeModule(animated: true) }

        let viewModel = GeneralErrorViewModel(
            error: error,
            isRetryAllowed: false,
            buttonAction: forceClose ? closeAction : { },
            closeAction: forceClose ? nil : { }
        )

        showError(with: viewModel, in: view)
    }
    
    /// Processing of infinite retry attempts
    /// With custom action on closing
    public static func process(error: GeneralError,
                               with retryAction: @escaping Callback,
                               in view: BaseView,
                               closeCallback: @escaping Callback) {
        let viewModel = GeneralErrorViewModel(
            error: error,
            isRetryAllowed: true,
            buttonAction: retryAction,
            closeAction: closeCallback,
            notClosable: false
        )
        
        showError(with: viewModel, in: view)
    }
    
    // MARK: - Private Methods
    public static func showError(with viewModel: GeneralErrorViewModel, in view: BaseView) {
        onMainQueue {
            let module = GeneralErrorModule(viewModel: viewModel)
            view.showChild(module: module)
        }
    }
}
