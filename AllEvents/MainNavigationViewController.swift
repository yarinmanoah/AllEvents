import UIKit
import CoreLocation

class MainNavigationViewController: UINavigationController {
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            showLoginScreen()
        } else {
            showIntroScreen()
        }
    }
    
    private func showIntroScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let introVC = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
            self.pushViewController(introVC, animated: true)
        }
    }
    
    private func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.pushViewController(loginVC, animated: true)
        }
    }
}
