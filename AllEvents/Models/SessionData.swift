import Foundation
import CoreLocation

class SessionManager: NSObject {
    var user: User?
    var locationManager: CLLocationManager
    var userLocation: CLLocation?
    
    static let shared = SessionManager()
    
    private override init() {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}
