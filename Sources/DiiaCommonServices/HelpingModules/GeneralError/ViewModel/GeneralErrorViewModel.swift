import Foundation
import DiiaNetwork
import DiiaCommonTypes

// MARK: - GeneralError
public enum GeneralError: Error {
    case otpTimeout
    case requestNotFound
    case noInternet
    case serverError
    case noRegistryAccess
    case documentNotFound
    case attemptsExhausted
    case alreadyExist
    case sumWasChanged
    case acquirerAbsentDocs
    case qrExpired
    case noReAuthMethods
    case camera(message: String)
    case custom(error: String)
    
    public init(networkError: NetworkError) {
        self = networkError == .noInternet ? .noInternet : .serverError
    }

    public var localizedDescription: String {
        switch self {
        case .otpTimeout:
            return R.Strings.error_otp_timeout.localized()
        case .requestNotFound:
            return R.Strings.error_request_not_found.localized()
        case .noInternet:
            return R.Strings.error_no_internet.localized()
        case .serverError:
            return R.Strings.error_server_error.localized()
        case .noRegistryAccess:
            return R.Strings.error_no_registry_access.localized()
        case .documentNotFound:
            return R.Strings.error_doc_not_found.localized()
        case .attemptsExhausted:
            return R.Strings.error_attempts_exhausted.localized()
        case .alreadyExist:
            return R.Strings.error_doc_already_exist.localized()
        case .sumWasChanged:
            return R.Strings.error_payment_sum_changed.localized()
        case .acquirerAbsentDocs:
            return R.Strings.error_acquirer_doc_absent.localized()
        case .qrExpired:
            return R.Strings.error_code_expired.localized()
        case .noReAuthMethods:
            return R.Strings.error_no_reauth_methods.localized()
        case .camera:
            return R.Strings.error_camera.localized()
        case .custom(let error):
            return error
        }
    }
    
    public var localizedDetails: String? {
        switch self {
        case .noInternet:
            return R.Strings.error_no_internet_description.localized()
        case .attemptsExhausted:
            return R.Strings.error_try_later.localized()
        default:
            return nil
        }
    }
}

// MARK: - GeneralErrorViewModel
public struct GeneralErrorViewModel {
    public let error: GeneralError
    public let isRetryAllowed: Bool
    public let buttonAction: Callback
    public let buttonTitle: String?
    public let closeAction: Callback?
    public let notClosable: Bool
    
    public init(error: GeneralError,
                isRetryAllowed: Bool,
                buttonAction: @escaping Callback,
                buttonTitle: String? = nil,
                closeAction: Callback?,
                notClosable: Bool = false) {
        self.error = error
        self.isRetryAllowed = isRetryAllowed
        self.buttonAction = buttonAction
        self.buttonTitle = buttonTitle
        self.closeAction = closeAction
        self.notClosable = notClosable
    }
}
