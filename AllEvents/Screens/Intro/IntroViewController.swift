
import CoreLocation
import UIKit

class IntroViewController: UIViewController {
    
    private var loginShown: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            SessionManager.shared.locationManager.delegate = self
            SessionManager.shared.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func showLoginViewController() {
        if !loginShown {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                loginShown = true
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
}

extension IntroViewController: CLLocationManagerDelegate {
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        showLoginViewController()
    }
}
