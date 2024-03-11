import Foundation
@testable import DiiaCommonServices

class DeepLinkManagerMock: DeepLinkManagerProtocol {
    private(set) var isParseCalled: Bool = false
    
    func parse(url: URL) -> Bool {
        isParseCalled.toggle()
        return isParseCalled
    }
}
