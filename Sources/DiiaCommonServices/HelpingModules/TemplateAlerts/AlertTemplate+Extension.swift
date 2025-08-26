
import Foundation
import DiiaCommonTypes

public extension AlertTemplate {
    static let generalErrorAlert = AlertTemplate(
        type: .middleCenterAlignAlert,
        isClosable: false,
        data: AlertTemplateData(
            icon: nil,
            title: R.Strings.general_next.localized(),
            description: nil,
            mainButton: AlertButtonModel(
                title: R.Strings.permissions_exit.localized(),
                icon: nil,
                action: .close),
            alternativeButton: nil)
    )
}
