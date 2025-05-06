
import Alamofire
import Foundation
import ReactiveKit
import DiiaNetwork
import DiiaCommonTypes

protocol AddressAPIClientProtocol {
    func getAddress(
        service: String,
        addressType: AddressType,
        addressRequest: AddressRequest?,
        pagination: PaginationModel?)
    -> Signal<AddressResponse, NetworkError>
}

class AddressAPIClient: ApiClient<AddressAPI>, AddressAPIClientProtocol {
    
    init(context: NetworkingContext) {
        super.init()

        sessionManager = context.session
        AddressAPI.host = context.host
        AddressAPI.headers = context.headers
    }
    
    func getAddress(service: String,
                    addressType: AddressType,
                    addressRequest: AddressRequest?,
                    pagination: PaginationModel?)
    -> Signal<AddressResponse, NetworkError> {
        return request(
            .getAddress(
                service: service,
                addressType: addressType,
                request: addressRequest,
                pagination: pagination
            ))
    }
}

public struct NetworkingContext {
    public let session: Alamofire.Session
    public let host: String
    public let headers: [String: String]?
    
    public init(session: Alamofire.Session, host: String, headers: [String: String]?) {
        self.session = session
        self.host = host
        self.headers = headers
    }
}
