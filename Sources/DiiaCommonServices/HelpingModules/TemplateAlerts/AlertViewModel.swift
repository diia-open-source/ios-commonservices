
import UIKit
import DiiaCommonTypes

public struct AlertViewModel {
    
    // MARK: - Properties
    public let isClosable: Bool
    public let icon: String?
    public let title: String
    public let description: String
    
    public let mainButton: AlertButtonModel
    public let alternativeButton: AlertButtonModel?
    
    public var hasIcon: Bool { icon != nil }
    public var hasAlternativeButton: Bool { alternativeButton != nil }
    
    // MARK: - Init
    public init(template: AlertTemplate) {
        self.isClosable = template.isClosable
        self.icon = template.data.icon
        self.title = template.data.title
        self.description = template.data.description ?? ""
        self.mainButton = template.data.mainButton
        self.alternativeButton = template.data.alternativeButton
    }
}
