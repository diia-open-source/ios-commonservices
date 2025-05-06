
import Foundation
import DiiaMVPModule
import DiiaCommonTypes

public protocol PaymentManagerProtocol: NSObjectProtocol {
    func startPayment(_ paymentRequest: PaymentRequestModel, in view: BaseView, callback: @escaping (AlertTemplateAction) -> Void)
}
