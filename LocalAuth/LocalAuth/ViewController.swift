import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    
    let context = LAContext()
    let reason = "Authenticate"
    var error: NSError?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func authenticate(_ sender: Any) {
        //getBiometryType()
        authenticateWithBiometry()
    }
    
    func getBiometryType() {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if #available(iOS 11.0, *) {
                if context.biometryType == LABiometryType.faceID {
                    self.showAlertController("Device supports Face ID.")
                } else if context.biometryType == LABiometryType.touchID {
                    self.showAlertController("Device supports Touch ID.")
                } else {
                    self.showAlertController("Device does not support Biometrics.")
                }
            }
        }
    }
    
    func authenticateWithBiometry() {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: {
                [unowned self] (success, error) in
                    if success {
                        self.showAlertController("Authentication Succeeded.")
                    } else {
                        self.showAlertController("Authentication Failed.")
                        if let nsError = error as NSError? {
                            switch nsError.domain {
                                case kLAErrorDomain:
                                    switch nsError.code {
                                        case Int(kLAErrorUserCancel):
                                            print("User cancelled.")
                                        case Int(kLAErrorBiometryLockout):
                                            print("Biometry lockout.")
                                        default:
                                            print("Unhandled error.")
                                        }
                                default:
                                    print("Unhandled error domain. Probably will not happen.")
                            }
                        }
                    }
            })
        }
    }
    
    func showAlertController(_ message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}


