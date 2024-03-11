import Foundation
import DiiaUIComponents
import DiiaCommonTypes

public struct ContactsInputModel: Codable {
    public let navigationPanel: NavigationPanel?
    public let title: String?
    public let description: String?
    public let text: String?
    public let phoneNumber: String?
    public let phone: String?
    public let email: String?
    public let attentionMessage: ParameterizedAttentionMessage?
    
    public init(navigationPanel: NavigationPanel?,
                title: String?,
                description: String?,
                text: String?,
                phoneNumber: String?,
                phone: String?,
                email: String?,
                attentionMessage: ParameterizedAttentionMessage?) {
        self.navigationPanel = navigationPanel
        self.title = title
        self.description = description
        self.text = text
        self.phoneNumber = phoneNumber
        self.phone = phone
        self.email = email
        self.attentionMessage = attentionMessage
    }
}
 
