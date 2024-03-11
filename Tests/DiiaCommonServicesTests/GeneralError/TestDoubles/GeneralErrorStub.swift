import Foundation
import DiiaCommonTypes
@testable import DiiaCommonServices

struct GeneralErrorStub {
    static func getViewModel(buttonAction: @escaping Callback = {},
                             closeAction: Callback? = nil) -> GeneralErrorViewModel {
        return .init(error: .noInternet,
                     isRetryAllowed: true,
                     buttonAction: buttonAction,
                     closeAction: closeAction)
    }
}
