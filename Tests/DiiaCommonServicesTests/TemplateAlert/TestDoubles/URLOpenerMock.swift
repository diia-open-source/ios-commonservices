import Foundation
import DiiaCommonTypes
@testable import DiiaCommonServices

class URLOpenerMock: URLOpenerProtocol {
    private(set) var isOpenUrlCalled: Bool = false
    
    func url(urlString: String?, linkType: String?) -> Bool {
        isOpenUrlCalled.toggle()
        return isOpenUrlCalled
    }
    
    func tryURL(urls: [String]) -> Bool {
        return true
    }
}
