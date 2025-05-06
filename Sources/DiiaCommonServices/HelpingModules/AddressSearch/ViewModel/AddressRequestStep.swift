
import Foundation
import DiiaCommonTypes

public class AddressRequestStep {
    public let parameters: [AddressRequestParameter]
    
    public init(parameters: [AddressRequestParameter]) {
        self.parameters = parameters
    }
    
    public func isValid() -> Bool {
        for param in parameters where !param.isValid() {
            return false
        }
        
        return true
    }
    
    public func request() -> AddressRequest? {
        if !isValid() { return nil }
        let values: [AddressRequestModel] = parameters.compactMap {
            if let value = $0.value, !value.isEmpty {
                return  AddressRequestModel(
                    type: $0.parameter.type,
                    id: $0.id,
                    value: value)
            }
            return nil
        }
        
        return AddressRequest(values: values)
    }
}

public class AddressRequestParameter {
    public let parameter: AddressParameter
    public var id: String?
    public var value: String?
    public var errorMessage: String?
    public var onChange: Callback?
    
    public init(parameter: AddressParameter) {
        self.parameter = parameter
    }
    
    public func isValid() -> Bool {
        if !parameter.mandatory {
            return (value ?? "").isEmpty ? true : regexpValidation()
        }
        return regexpValidation() || (id ?? "").count > 0
    }
    
    private func regexpValidation() -> Bool {
        if let validation = parameter.validation {
            let prefix = validation.flags?.count ?? 0 > 0 ? "(?\((validation.flags ?? []).joined()))" : ""
            return value?.isValid(regex: prefix + validation.regexp) ?? false
        }
        
        return (value ?? "").count > 0
    }
}
