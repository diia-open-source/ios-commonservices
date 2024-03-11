import UIKit

internal extension R {
    enum Image: String, CaseIterable {
        case backNavAction
        case lightCloseIcon
        
        var image: UIImage? {
            return UIImage(named: rawValue, in: Bundle.module, compatibleWith: nil)
        }
        
        var name: String {
            return rawValue
        }
    }
}
