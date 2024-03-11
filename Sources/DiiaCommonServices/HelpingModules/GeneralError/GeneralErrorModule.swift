import UIKit
import DiiaMVPModule
import DiiaUIComponents

public class GeneralErrorModule: BaseModule {
    private let view: GeneralErrorViewController
    private let presenter: GeneralErrorPresenter
    
    public init(viewModel: GeneralErrorViewModel) {
        view = GeneralErrorViewController.storyboardInstantiate(bundle: Bundle.module)
        presenter = GeneralErrorPresenter(view: view, viewModel: viewModel)
        view.presenter = presenter
    }

    public func viewController() -> UIViewController {
        let vc = ChildContainerViewController()
        vc.childSubview = view
        vc.presentationStyle = .fullscreen
        return vc
    }
}
