import UIKit
import DiiaMVPModule
import DiiaCommonTypes

public protocol TemplateAlertAction: BasePresenter {
    func close()
	func onMainButton()
    func onAlternativeButton()
}

public protocol TemplateAlertView: BaseView {
    func configure(with viewModel: AlertViewModel)
    func close()
}

final class TemplateAlertPresenter: TemplateAlertAction {
    
    // MARK: - Properties
    unowned var view: TemplateAlertView
    private let viewModel: AlertViewModel
    private let callback: (AlertTemplateAction) -> Void
    private let onClose: Callback
    
    // MARK: - Init
    init(
        view: TemplateAlertView,
        viewModel: AlertViewModel,
        callback: @escaping (AlertTemplateAction) -> Void,
        onClose: @escaping Callback
    ) {
        self.view = view
        self.viewModel = viewModel
        self.callback = callback
        self.onClose = onClose
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.configure(with: viewModel)
    }
    
    func close() {
        view.close()
        onClose()
    }
    
    func onMainButton() {
        view.close()
        callback(viewModel.mainButton.action)
    }
    
    func onAlternativeButton() {
        view.close()
        guard let action = viewModel.alternativeButton?.action else { return }
        callback(action)
    }
}
