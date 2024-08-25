import MapKit
import UIKit

protocol MapViewControllerDelegate: AnyObject {
    func onLocationSaved(coordinates: CLLocationCoordinate2D, address: String)
}

class MapViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: MapViewControllerDelegate?
    
    private var selectedLocationAddress: String?
    private var selectedLocationCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        saveButton.isEnabled = false
        setupTapGesture()
    }
    
    @IBAction func onSaveButtonPressed(_ sender: Any) {
        guard let selectedLocationCoordinates, let selectedLocationAddress else {
            return
        }
        
        self.delegate?.onLocationSaved(coordinates: selectedLocationCoordinates, address: selectedLocationAddress)
        self.dismiss(animated: true)
    }
    
    func geocodeAddressString(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(String(describing: error))")
                return
            }
            if let placemark = placemarks?.first {
                self.mapView.removeAnnotations(self.mapView.annotations)
                let coordinate = placemark.location?.coordinate
                var region = MKCoordinateRegion(center: coordinate!, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                region.center = coordinate!
                self.mapView.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate!
                annotation.title = address
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard error == nil else {
                print("Reverse geocoding error: \(String(describing: error))")
                completion(nil)
                return
            }
            if let placemark = placemarks?.first {
                let address = [placemark.name, placemark.locality, placemark.administrativeArea, placemark.country].compactMap { $0 }.joined(separator: ", ")
                completion(address)
            } else {
                completion(nil)
            }
        }
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        reverseGeocodeCoordinate(coordinate) { [weak self] address in
            guard let self else { return }
            annotation.title = address
            self.selectedLocationAddress = address
            self.selectedLocationCoordinates = coordinate
            self.saveButton.isEnabled = true
        }
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let address = searchBar.text {
            geocodeAddressString(address)
        }
    }
}
