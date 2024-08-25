import CoreLocation
import UIKit

class EventsListViewController: AllEventsScrollableBaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var filterView: FilterView!
    
    private var allEvents: [Event] = []
    private var eventsToShow: [Event] = []
    private var selectedFilter: EventFilter = .allEvent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SessionManager.shared.locationManager.delegate = self
        self.searchBar.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "EventTableViewCell", bundle: .main), forCellReuseIdentifier: EventTableViewCell.identifier)
        
        self.filterView.delegate = self
        self.filterView.configure(filter: selectedFilter, presentingVC: self)
        
        startUpdatingLocation()
        fetchEvents()
    }
    
    private func fetchEvents() {
        showLoadingAnimation()
        EventsManager().getEvents(completion: { [weak self] events in
            guard let self else { return }
            self.hideLoadingAnimation()
            self.allEvents = events
            self.allEvents.forEach { event in
                guard let longitude = event.longitute, let latitude = event.latitude else { return }
                event.distance = self.calculateDistance(longitude: longitude, latitude: latitude)
            }
            
            if selectedFilter == .attendingEvents {
                self.eventsToShow = events.filter({
                    $0.attentedUsers?.contains(where: { $0.uid == SessionManager.shared.user?.uid }) ?? false
                })
            } else {
                self.eventsToShow = events.filter({
                    self.selectedFilter.connectedTypes.contains($0.type ?? .other) &&
                    ($0.attentedUsers?.count ?? 0) < ($0.maxNumberOfAttendence ?? 0)
                })
            }
            
            self.eventsToShow.sort(by: {$0.distance ?? 0 < $1.distance ?? 0 })
            
            emptyStateView.isHidden = !eventsToShow.isEmpty
           
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventFormViewController {
            vc.delegate = self
        }
    }
    
    private func calculateDistance(longitude: Double, latitude: Double) -> Double? {
        let coordinate = CLLocation(latitude: latitude, longitude: longitude)
        let userLocation = SessionManager.shared.userLocation
        
        if let distance = userLocation?.distance(from: coordinate) {
            return distance / 1000.0
        }
        
        return nil
    }
    
    private func startUpdatingLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                SessionManager.shared.locationManager.startUpdatingLocation()
            }
        }
    }
    
    private func filterEventsByText(text: String) {
        if text.isEmpty {
            self.eventsToShow = allEvents
        } else {
            self.eventsToShow = self.allEvents.filter({
                $0.title.lowercased().contains(text.lowercased()) ||
                ($0.description?.lowercased().contains(text.lowercased()) ?? false)
            })
        }
        
        self.tableView.reloadData()
    }
    
    private func showEventScreen(event: Event) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let eventVC = storyboard.instantiateViewController(withIdentifier: "EventViewController") as? EventViewController {
            eventVC.event = event
            eventVC.delegate = self
            self.navigationController?.pushViewController(eventVC, animated: true)
        }
    }
}

extension EventsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterEventsByText(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension EventsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: EventTableViewCell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as? EventTableViewCell else { return UITableViewCell() }
        
        cell.configure(event: eventsToShow[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.eventsToShow.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventsToShow[indexPath.row]
        showEventScreen(event: event)
    }
}

extension EventsListViewController: EventFormViewControllerDelegate {
    func eventFormViewControllerDidCreateEvent() {
        self.fetchEvents()
    }
}

extension EventsListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            SessionManager.shared.userLocation = location
            SessionManager.shared.locationManager.stopUpdatingLocation()
            
            fetchEvents()
        }
    }
}

extension EventsListViewController: FilterViewDelegate {
    
    func filterViewDidSelectFilter(_ filterView: FilterView, filter: EventFilter) {
        if filter != selectedFilter {
            self.selectedFilter = filter
            self.fetchEvents()
        }
    }
}

extension EventsListViewController: EventViewControllerDelegate {
    func eventDidChangeParticipants() {
        self.fetchEvents()
    }
}
