
import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes

protocol AddressSearchAction: BasePresenter {
    func openContextMenu()
	func select()
    func getScreenCode() -> String?
}

final class AddressSearchPresenter: AddressSearchAction {
	// MARK: - Properties
    unowned var view: AddressSearchView
    
    private let contextMenuProvider: ContextMenuProviderProtocol
    private let apiClient: AddressAPIClientProtocol
    private let bag = DisposeBag()
    
    private let handler: AddressSearchHandlerProtocol
    
    private var addressRequestSteps: [AddressRequestStep] = []

    private var address: AddressModel? {
        didSet {
            view.setButtonAvailability(isAvailable: address != nil)
        }
    }
    
    private var currentRequest: Disposable?

    // MARK: - Init
    init(view: AddressSearchView,
         handler: AddressSearchHandlerProtocol,
         contextMenuProvider: ContextMenuProviderProtocol,
         networkingContext: NetworkingContext) {
        self.view = view
        self.handler = handler
        self.contextMenuProvider = contextMenuProvider
        self.apiClient = AddressAPIClient(context: networkingContext)
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.setTitle(title: handler.title)
        view.setButtonTitle(title: handler.buttonTitle)
        view.setContextMenuAvailable(isAvailable: contextMenuProvider.hasContextMenu())
        fetchAddress()
    }
    
    func openContextMenu() {
        guard contextMenuProvider.hasContextMenu() else { return }
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func select() {
        guard let address = address else {
            updateRequestStep(atIndex: addressRequestSteps.count-1, forcedFetchAddress: true, forcedCompletion: true)
            return
        }
        handler.onAddressSelected(address: address, view: view)
    }
    
    func getScreenCode() -> String? {
        return handler.screenCode
    }
    
    // MARK: - Private Methods
    private func fetchAddress(forcedCompletion: Bool = false) {
        view.setState(state: .loading)
        currentRequest?.cancel()
        let request = apiClient
            .getAddress(service: handler.publicService, addressType: handler.addressType, addressRequest: addressRequestSteps.last?.request(), pagination: nil)
            .observe { [weak self] (event) in
                switch event {
                case .completed:
                    return
                case .next(let response):
                    self?.processResponse(response: response, forcedCompletion: forcedCompletion)
                case .failed(let error):
                    self?.handleError(error: error, retryAction: { [weak self] in self?.fetchAddress(forcedCompletion: forcedCompletion) })
                }
                self?.view.setState(state: .ready)
            }
            
        request.dispose(in: bag)
        
        currentRequest = request
    }
    
    private func updateRequestStep(atIndex index: Int, forcedFetchAddress: Bool, forcedCompletion: Bool) {
        address = nil
        
        if self.addressRequestSteps.count > index {
            let step = self.addressRequestSteps[index]
            if step.isValid() {
                self.removeStepsIfNeeded(after: index)
                if forcedFetchAddress {
                    self.fetchAddress(forcedCompletion: forcedCompletion)
                } else {
                    self.view.setButtonAvailability(isAvailable: true)
                }
            } else {
                self.view.setButtonAvailability(isAvailable: false)
            }
        }
    }
    
    private func processResponse(response: AddressResponse, forcedCompletion: Bool) { // swiftlint:disable:this cyclomatic_complexity
        address = response.address
        if let address = address, forcedCompletion {
            handler.onAddressSelected(address: address, view: view)
            return
        }
        
        let indexStep = addressRequestSteps.count
        let isSingleParameter = response.parameters?.count == 1
        let appendingStep = AddressRequestStep(
            parameters: (response.parameters ?? [])
                .map {
                    let param = AddressRequestParameter(parameter: $0)
                    param.onChange = { [weak self] in
                        guard let self = self else { return }
                        let forcedFetchAddress = isSingleParameter && param.parameter.input != .textField
                        if param.errorMessage != nil {
                            self.removeStepsIfNeeded(after: indexStep)
                        } else {
                            self.updateRequestStep(atIndex: indexStep, forcedFetchAddress: forcedFetchAddress, forcedCompletion: false)
                        }
                    }
                    return param
                }
        )
        if !appendingStep.parameters.isEmpty {
            addressRequestSteps.append(appendingStep)
        }
        if let title = response.title {
            view.setHeader(header: title)
        }
        if let description = response.description {
            view.setDescription(description: description)
        }
        if let attentionMessage = response.attentionMessage {
            view.setAttention(attention: attentionMessage)
        }
        if let template = response.template {
            TemplateHandler.handle(template, in: view) { [weak self] action in
                guard let view = self?.view else { return }
                switch action {
                case .refill:
                    self?.addressRequestSteps = []
                    self?.view.setSteps(steps: [])
                    self?.fetchAddress()
                default:
                    self?.handler.handleTemplateAction(action: action, view: view)
                }
            }
        }
        if !appendingStep.parameters.isEmpty {
            view.appendSteps(steps: [appendingStep])
        }
        if appendingStep.isValid() {
            view.setButtonAvailability(isAvailable: true)
        }
    }
    
    private func removeStepsIfNeeded(after index: Int) {
        addressRequestSteps = Array(addressRequestSteps[0...index])
        view.removeInputs(after: addressRequestSteps.map { $0.parameters.count }.reduce(0, +))
    }
    
    private func handleError(error: NetworkError, retryAction: @escaping Callback) {
        GeneralErrorsHandler.process(
            error: .init(networkError: error),
            with: retryAction,
            didRetry: false,
            in: view
        )
    }
}
