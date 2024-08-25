import MapKit
import UIKit

class NavigationManager: NSObject {
    
    static let shared = NavigationManager()
    
    private override init() {}
    
    func showNavigationOptions(presentingVC: UIViewController, event: Event) {
        guard let latitude = event.latitude, let longitute = event.longitute else { return }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitute)
        
        let alert = UIAlertController(title: "Navigate", message: "Choose an app to navigate with:", preferredStyle: .actionSheet)
        
        if canOpenGoogleMaps() {
            alert.addAction(UIAlertAction(title: "Google Maps", style: .default) { _ in
                self.openGoogleMaps(to: coordinate)
            })
        }
        
        if canOpenAppleMaps() {
            alert.addAction(UIAlertAction(title: "Apple Maps", style: .default) { _ in
                self.openAppleMaps(to: coordinate)
            })
        }
        
        if canOpenWaze() {
            alert.addAction(UIAlertAction(title: "Waze", style: .default) { _ in
                self.openWaze(to: coordinate)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        presentingVC.present(alert, animated: true, completion: nil)
    }
    
    private func canOpenGoogleMaps() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
    }
    
    private func canOpenAppleMaps() -> Bool {
        return true
    }
    
    private func canOpenWaze() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "waze://")!)
    }
    
    private func openGoogleMaps(to coordinate: CLLocationCoordinate2D) {
        if let url = URL(string: "comgooglemaps://?daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openAppleMaps(to coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Destination"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    private func openWaze(to coordinate: CLLocationCoordinate2D) {
        if let url = URL(string: "waze://?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=yes") {
            UIApplication.shared.open(url)
        }
    }
    
}
