import UIKit

class EventTableViewCell: UITableViewCell {
    static let identifier = "EventTableViewCell"
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventCounterLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventDistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.eventImageView.contentMode = .scaleToFill
        self.eventImageView.layer.cornerRadius = 30
        self.eventImageView.layer.borderColor = UIColor.black.cgColor
        self.eventImageView.layer.borderWidth = 1.0
        self.eventImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configure(event: Event) {
        self.eventImageView.image = event.type?.image
        self.eventTitleLabel.text = event.title
        self.eventDateLabel.text = "Event Date: \(event.date?.formatted() ?? "")"
        self.eventCounterLabel.text = "Participants: \(event.attentedUsers?.count ?? 0)/\(event.maxNumberOfAttendence ?? 0)"
        if let distance = event.distance {
            self.eventDistanceLabel.text = "\(String(format: "%.2f", distance)) km from you"
        } else {
            self.eventDistanceLabel.text = "N/A"
        }
    }
}
