
import Foundation
import DiiaMVPModule
import DiiaCommonTypes

public protocol AddressSearchHandlerProtocol {
    var publicService: String { get }
    var screenCode: String? { get }
    var addressType: AddressType { get }
    var title: String { get }
    var buttonTitle: String { get }
    func onAddressSelected(address: AddressModel, view: AddressSearchView)
    func handleTemplateAction(action: AlertTemplateAction, view: BaseView)
}

public struct AddressSearchHandler: AddressSearchHandlerProtocol {
    public let publicService: String
    public let screenCode: String?
    public let addressType: AddressType
    public let title: String
    public let buttonTitle: String
    private let callback: (AddressModel, BaseView) -> Void
    private let templateAction: ((AlertTemplateAction, BaseView) -> Void)?
    
    public init(
        publicService: String,
        screenCode: String? = nil,
        addressType: AddressType,
        title: String,
        buttonTitle: String? = nil,
        callback: @escaping (AddressModel, BaseView) -> Void,
        templateAction: ((AlertTemplateAction, BaseView) -> Void)? = nil
    ) {
        self.publicService = publicService
        self.screenCode = screenCode
        self.addressType = addressType
        self.title = title
        self.buttonTitle = buttonTitle ?? R.Strings.general_save.localized()
        self.callback = callback
        self.templateAction = templateAction
    }
    
    public func onAddressSelected(address: AddressModel, view: AddressSearchView) {
        callback(address, view)
    }
    
    public func handleTemplateAction(action: AlertTemplateAction, view: BaseView) {
        templateAction?(action, view)
    }
}
