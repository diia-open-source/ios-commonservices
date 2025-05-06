
import UIKit

extension CACornerMask {
    static let topLeft: CACornerMask = .layerMinXMinYCorner
    static let topRight: CACornerMask = .layerMaxXMinYCorner
    static let bottomLeft: CACornerMask = .layerMinXMaxYCorner
    static let bottomRight: CACornerMask = .layerMaxXMaxYCorner
    static let allCorners: CACornerMask = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    static let topCorners: CACornerMask = [.topLeft, .topRight]
    static let bottomCorners: CACornerMask = [.bottomLeft, .bottomRight]
}
