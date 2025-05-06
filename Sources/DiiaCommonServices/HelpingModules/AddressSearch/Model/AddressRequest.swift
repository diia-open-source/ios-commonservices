
import Foundation
import UIKit
import DiiaUIComponents
import DiiaCommonTypes

public struct AddressRequest: Codable {
    public let values: [AddressRequestModel]?
}

public struct AddressRequestModel: Codable {
    public let type: String
    public let id: String?
    public let value: String?
}

public struct PaginationModel: Codable {
    public let skip: Int?
    public let limit: Int?
    public let search: String?
    
    public init(skip: Int? = nil,
         limit: Int? = nil,
         search: String? = nil
    ) {
        self.skip = skip
        self.limit = limit
        self.search = search
    }
}

 struct URLOpenerImpl: URLOpenerProtocol {
     func url(urlString: String?, linkType: String?) -> Bool {
         if let urlString = urlString, let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
             return true
         }
         
         return false
     }
    
     func tryURL(urls: [String]) -> Bool {
         let application = UIApplication.shared
         for strUrl in urls {
             if let url = URL(string: strUrl), application.canOpenURL(url) {
                 application.open(url)
                 return true
             }
         }
         return false
     }
 }
