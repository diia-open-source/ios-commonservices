import Foundation

enum R {
    enum Strings: String, CaseIterable {
        // MARK: - General
        case general_next
        case general_retry
        case general_ok
        case permissions_exit
        
        // MARK: - Errors
        case error_otp_timeout
        case error_request_not_found
        case error_no_internet
        case error_no_internet_description
        case error_server_error
        case error_no_registry_access
        case error_doc_not_found
        case error_attempts_exhausted
        case error_doc_already_exist
        case error_payment_sum_changed
        case error_acquirer_doc_absent
        case error_code_expired
        case error_no_reauth_methods
        case error_camera
        case error_try_later
        
        // MARK: - ContactsInput
        case contacts_input_title
        case contacts_input_filled_from_bank_id
        case contacts_input_contact_phone
        case contacts_input_wrong_phone
        case contacts_input_contact_email
        case contacts_input_wrong_email
        
        func localized() -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.module, comment: "")
            return localized
        }
        
        func formattedLocalized(arguments: CVarArg...) -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.module, comment: "")
            return String(format: localized, arguments)
        }
    }
}
