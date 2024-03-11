import Foundation
import DiiaCommonTypes
@testable import DiiaCommonServices

struct AlertTemplateStub {
    static let alert: AlertTemplate = .init(type: .middleCenterAlignAlert,
                                            isClosable: false,
                                            data: AlertTemplateData(icon: nil,
                                                                    title: "template_test",
                                                                    description: nil,
                                                                    mainButton: AlertButtonModel(title: "main_test",
                                                                                                 icon: nil,
                                                                                                 action: .close),
                                                                    alternativeButton: AlertButtonModel(title: "alternative_test",
                                                                                                        icon: nil,
                                                                                                        action: .repeat))
    )
}
