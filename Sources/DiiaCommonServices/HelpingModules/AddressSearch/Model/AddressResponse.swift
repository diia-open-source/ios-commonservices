
import Foundation
import DiiaUIComponents
import DiiaCommonTypes

public struct AddressResponse: Codable {
    public let title: String?
    public let description: String?
    public let attentionMessage: ParameterizedAttentionMessage?
    public let address: AddressModel?
    public let parameters: [AddressParameter]?
    public let template: AlertTemplate?
}

public struct AddressParameter: Codable {
    public let type: String
    public let label: String
    public let hint: String?
    public let mask: String?
    public let input: AddressParameterInputType
    public let source: AddressSource?
    public let mandatory: Bool
    public let validation: InputValidationModel?
    public let searchPlaceholder: String?
}

public enum AddressParameterInputType: String, Codable {
    case list
    case singleCheck
    case textField
}

public struct AddressSource: Codable {
    public let items: [AddressSourceItem]
    public let total: Int?
    
    public init(items: [AddressSourceItem], total: Int?) {
        self.items = items
        self.total = total
    }
}

public struct AddressSourceItem: Codable {
    public let id: String
    public let name: String
    public let errorMessage: String?
    public let disabled: Bool?
}

public struct AddressModel: Codable {
    public let resourceId: String
    public let fullName: String
    
    public init(resourceId: String, fullName: String) {
        self.resourceId = resourceId
        self.fullName = fullName
    }
}
