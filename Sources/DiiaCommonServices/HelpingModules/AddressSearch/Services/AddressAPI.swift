
import Foundation
import DiiaNetwork
import DiiaCommonTypes

enum AddressAPI: CommonService {
    
    static var host: String = ""
    static var headers: [String: String]?
    
    var host: String {
        return AddressAPI.host
    }
    
    var timeoutInterval: TimeInterval {
        return 30
    }
    
    var headers: [String: String]? {
        return AddressAPI.headers
    }
    
    var analyticsAdditionalParameters: String? { return nil }
    
    case getAddress(service: String, addressType: AddressType, request: AddressRequest?, pagination: PaginationModel?)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getAddress(let service, let addressType, _, _):
            return "v2/address/\(service)/\(addressType)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAddress(_, _, let request, let pagination):
            let values: [Any] = (request?.values ?? []).compactMap {
                if $0.id == nil && $0.value == nil {
                    return nil
                }
                return $0.dictionary
            }
            if values.count == 0 { return nil }
            return ["values": values]
                .merging(pagination?.dictionary ?? [:], uniquingKeysWith: { (_, new) in new })
        }
    }
    
    var analyticsName: String {
        switch self {
        case .getAddress:
            return NetworkActionKey.addressGet.rawValue
        }
    }
    
    private enum NetworkActionKey: String {
        case addressGet
    }
}
