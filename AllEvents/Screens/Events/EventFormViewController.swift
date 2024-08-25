import MapKit
import UIKit

protocol EventFormViewControllerDelegate: AnyObject {
    func eventFormViewControllerDidCreateEvent()
}

class EventFormViewController: AllEventsScrollableBaseViewController {
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var eventTitleErrorLabel: UILabel!
    @IBOutlet weak var eventDescriptionTextField: UITextField!
    @IBOutlet weak var eventDescriptionErrorLabel: UILabel!
    @IBOutlet weak var participantsNumberTextField: UITextField!
    @IBOutlet weak var participantsErrorLabel: UILabel!
    @IBOutlet weak var eventTypePickerView: UIPickerView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var smallMapView: MKMapView!
    @IBOutlet weak var locationErrorLabel: UILabel!
    
    var selectedAddress: String?
    var selectedCoordinates: CLLocationCoordinate2D?
    
    weak var delegate: EventFormViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroundPressed))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(onMapPressed))
        smallMapView.addGestureRecognizer(mapTapGesture)
        
        self.locationErrorLabel.isHidden = true
        
        self.eventTitleTextField.delegate = self
        self.eventTitleErrorLabel.isHidden = true
        
        self.eventDescriptionTextField.delegate = self
        self.eventDescriptionErrorLabel.isHidden = true
        
        self.participantsNumberTextField.delegate = self
        self.participantsErrorLabel.isHidden = true
        
        self.eventTypePickerView.delegate = self
        self.eventTypePickerView.dataSource = self
        self.datePickerView.contentHorizontalAlignment = .leading
    }
    
    @objc private func onBackgroundPressed() {
        self.view.currentFirstResponder?.resignFirstResponder()
    }
    
    @objc private func onMapPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let fullMapVC = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            fullMapVC.modalPresentationStyle = .fullScreen
            fullMapVC.delegate = self
            self.present(fullMapVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func onCancelPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func validateInput(title: String, description: String, particants: Int) -> Bool {
        var isValid = true
        
        if !title.isEmpty {
            eventTitleErrorLabel.isHidden = true
        } else {
            eventTitleErrorLabel.isHidden = false
            isValid = false
        }
        
        if !description.isEmpty {
            eventDescriptionErrorLabel.isHidden = true
        } else {
            eventDescriptionErrorLabel.isHidden = false
            isValid = false
        }
        
        if particants >= 2 {
            participantsErrorLabel.isHidden = true
        } else {
            participantsErrorLabel.isHidden = false
            isValid = false
        }
        
        if selectedAddress != nil && selectedCoordinates != nil {
            locationErrorLabel.isHidden = true
        } else {
            locationErrorLabel.isHidden = false
            isValid = false
        }
        
        return isValid
    }

    
    @IBAction func onCreateButtonPressed(_ sender: Any) {
        guard let title = eventTitleTextField.text,
              let description = eventDescriptionTextField.text,
              let participants = participantsNumberTextField.text?.isEmpty == true ? 0 : Int(participantsNumberTextField.text ?? "0"),
              validateInput(title: title, description: description, particants: participants) else { return }
        
        let event = Event(
            title: title,
            description: description,
            date: datePickerView.date,
            address: self.selectedAddress,
            longitute: self.selectedCoordinates?.longitude,
            latitude: self.selectedCoordinates?.latitude,
            maxNumberOfAttendence: participants,
            attentedUsers: [SessionManager.shared.user].compactMap { $0 },
            type: EventType.allCases[eventTypePickerView.selectedRow(inComponent: 0)]
        )
        
        showLoadingAnimation()
        EventsManager().createEvent(event: event, completion: { [weak self] in
            guard let self else { return }
            self.hideLoadingAnimation()
            self.dismiss(animated: true, completion: {
                self.delegate?.eventFormViewControllerDidCreateEvent()
            })
        })
    }
}

extension EventFormViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return gestureRecognizer.view == self.view
    }
}

extension EventFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == eventTitleTextField {
            return eventDescriptionTextField.becomeFirstResponder()
        } else if textField == eventDescriptionTextField {
            return participantsNumberTextField.becomeFirstResponder()
        }
        
        return true
    }
}

extension EventFormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        EventType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EventType.allCases[row].title
    }
}

extension EventFormViewController: MapViewControllerDelegate {
    
    func onLocationSaved(coordinates: CLLocationCoordinate2D, address: String) {
        self.selectedAddress = address
        self.selectedCoordinates = coordinates
        
        self.smallMapView.removeAnnotations(smallMapView.annotations)
        var region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = coordinates
        self.smallMapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = address
        self.smallMapView.addAnnotation(annotation)
    }
}
