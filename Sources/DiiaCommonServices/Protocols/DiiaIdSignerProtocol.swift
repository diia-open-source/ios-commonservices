
import UIKit
import DiiaCommonTypes
import DiiaNetwork
import ReactiveKit
import DiiaMVPModule

public protocol DiiaIdSignerProtocol: NSObjectProtocol {
    var delegate: DiiaSigningDelegate? { get set }
    func checkSignaturesState()
    func setSignatureIdentifiers(_ signIdentifiers: [DiiaIdIdentifier])
    func sign(flow: DiiaIdSigningFlow, verificationFlow: VerificationFlowProtocol)
    func sign(verificationFlow: VerificationFlowProtocol)
    func hardCreateAndSign(flow: DiiaIdSigningFlow, verificationFlow: VerificationFlowProtocol)
    func createSignature(completion: @escaping (Bool) -> Void)
    func reset()
}

public protocol DiiaSigningDelegate: AnyObject {
    func signingView() -> BaseView
    func getHashes(processId: String) -> Signal<TemplatedResponse<HashedFileList>, NetworkError>
    func onSigningStateChanged(state: DiiaSigningState)
}

public enum DiiaSigningState {
    case signingNotAvailable
    case signingAvailable
    case creatingDiiaId
    case signingProcessing
    case error(error: NetworkError, retryAction: () -> Void)
    case cancelled
    case template(template: AlertTemplate)
    case signingFinished(hashes: [HashedFile], signedHashes: [Data])
}

public extension DiiaIdSignerProtocol {
    func sign(verificationFlow: VerificationFlowProtocol) {
        sign(flow: .default, verificationFlow: verificationFlow)
    }
}
