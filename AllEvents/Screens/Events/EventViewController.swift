import MapKit
import UIKit

protocol EventViewControllerDelegate: AnyObject {
    func eventDidChangeParticipants()
}

class EventViewController: UIViewController {
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var participantsView: ParticipantsSummaryView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var navigateButton: UIButton!
    @IBOutlet weak var attendButton: UIButton!
    @IBOutlet weak var unattedButton: UIButton!
    
    var event: Event?
    weak var delegate: EventViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = SessionManager.shared.user
        eventTitleLabel.text = event?.title
        eventDescriptionLabel.text = event?.description
        eventDateLabel.text = event?.date?.formatted()
        participantsView.configure(event: event)
        addressLabel.text = event?.address
        
        unattedButton.isHidden = !(event?.isAttending(userId: user?.uid) ?? false)
        attendButton.isHidden = event?.isAttending(userId: user?.uid) ?? true
        
        
        self.mapView.removeAnnotations(mapView.annotations)
        if let longitute = event?.longitute, let latitude = event?.latitude {
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitute)
            var region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            region.center = coordinates
            self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = event?.address
            self.mapView.addAnnotation(annotation)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        navigateButton.layer.cornerRadius = navigateButton.frame.height / 2
        navigateButton.clipsToBounds = true
    }

    @IBAction func onAttendEventPressed(_ sender: Any) {
        if let user = SessionManager.shared.user, let eventId = event?.uid {
            showLoadingAnimation()
            EventsManager().attendToEvent(user: user, eventId: eventId) { [weak self] isSuccess in
                guard let self else { return }
                self.hideLoadingAnimation()
                if isSuccess {
                    self.delegate?.eventDidChangeParticipants()
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert(text: "Failed to attend this event, try again later")
                }
            }
        }
    }
    
    @IBAction func onNavigateButtonPressed(_ sender: Any) {
        guard let event else { return }
        NavigationManager.shared.showNavigationOptions(presentingVC: self, event: event)
    }
    
    @IBAction func onShareButtonPressed(_ sender: Any) {
        guard let event else { return }
        ShareManager.startShareFlow(presentingVC: self, event: event)
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onUnattentEventPressed(_ sender: Any) {
        if let user = SessionManager.shared.user, let eventId = event?.uid {
            showLoadingAnimation()
            EventsManager().unattendEvent(user: user, eventId: eventId) { [weak self] isSuccess in
                guard let self else { return }
                self.hideLoadingAnimation()
                if isSuccess {
                    self.delegate?.eventDidChangeParticipants()
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert(text: "Failed to unattend this event, try again later")
                }
            }
        }
    }
}
