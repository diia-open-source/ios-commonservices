
import Foundation
import DiiaMVPModule
import DiiaCommonTypes

public enum PaymentResult {
    case template(action: AlertTemplateAction)
    case nextStep(nextStep: String)
}

public protocol PaymentManagerProtocol: NSObjectProtocol {
    /// Starts the payment process with the provided request and view context.
    ///
    /// Implementations of this method should initiate the payment flow using the provided
    /// `paymentRequest` details, display the necessary UI within the given `view`, and
    /// return the result through the `callback`.
    ///
    /// - Parameters:
    ///   - paymentRequest: A `PaymentRequestModel` containing all necessary payment details,
    ///     such as amount, currency, and any required metadata.
    ///   - view: A `BaseView` instance in which the payment-related UI will be presented.
    ///   - callback: A closure to be called upon completion of the payment process.
    ///     Provides a `PaymentResult` indicating success, failure, or the next step in the process.
    ///
    /// - SeeAlso: `PaymentResult`
    func startPayment(_ paymentRequest: PaymentRequestModel, in view: BaseView, callback: @escaping (PaymentResult) -> Void)
}

public extension PaymentManagerProtocol {
    /// Starts the payment process with the provided parameters.
    ///
    /// This method is intended **for backward compatibility only** and should not be used in new code.
    /// It delegates execution to the internal `startPayment(_:in:callback:)` method but ignores the
    /// `.successNextStep` case, handling only `.successAction`.
    ///
    /// - Parameters:
    ///   - paymentRequest: A `PaymentRequestModel` containing all necessary data to start the payment process.
    ///   - view: An instance of `BaseView` where the payment will be performed.
    ///   - callback: A closure that will be called on successful payment completion with an `AlertTemplateAction`.
    ///
    /// - SeeAlso: `startPayment(_:in:callback:)`
    @available(*, deprecated, message: "Use the newer startPayment(_:in:callback:) method that handles all result cases.")
    func startPayment(_ paymentRequest: PaymentRequestModel, in view: BaseView, callback: @escaping (AlertTemplateAction) -> Void) {
        self.startPayment(
            paymentRequest,
            in: view,
            callback: { result in
                switch result {
                case .template(let action):
                    callback(action)
                case .nextStep:
                    break
                }
            })
    }
}
