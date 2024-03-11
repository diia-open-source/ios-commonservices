import Foundation
import Alamofire
import ReactiveKit

public class ReachabilityHelper {

    // MARK: - Properties
    private let reachabilityManager = Alamofire.NetworkReachabilityManager.default
    public let statusSignal = PassthroughSubject<Bool, Never>()

    // MARK: - Singleton
    public static let shared = ReachabilityHelper()
    private init() {}

    // MARK: - Public Methods
    public func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            switch status {
            case .reachable:
                self.statusSignal.receive(true)
            case .notReachable, .unknown:
                self.statusSignal.receive(false)
            }
        })
    }

    public func isReachable() -> Bool {
        return reachabilityManager?.isReachable ?? false
    }

    public static func reachabilityCheck() -> Signal<Void, GeneralError> {
        return Signal { observer in
            if ReachabilityHelper.shared.isReachable() {
                observer.receive(lastElement: ())
            } else {
                observer.receive(completion: .failure(.noInternet))
            }
            return SimpleDisposable()
        }
    }
}
