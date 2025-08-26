
import UIKit
import DiiaMVPModule

protocol GeneralErrorAction: BasePresenter {
    func onAction()
    func onClose()
}

final class GeneralErrorPresenter: GeneralErrorAction {
    
    // MARK: - Properties
    private unowned let view: GeneralErrorView
    private let viewModel: GeneralErrorViewModel

    // MARK: - Init
    init(view: GeneralErrorView, viewModel: GeneralErrorViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.configure(with: viewModel)
    }
    
    func onAction() {
        viewModel.buttonAction()
    }
    
    func onClose() {
        viewModel.closeAction?()
    }
}
