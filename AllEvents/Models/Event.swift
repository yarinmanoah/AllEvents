import UIKit

class Event: Codable {
    var uid: String
    var title: String
    var description: String?
    var date: Date?
    var address: String?
    var longitute: Double?
    var latitude: Double?
    var maxNumberOfAttendence: Int?
    var attentedUsers: [User]?
    var type: EventType?
    var distance: Double?
    
    init(title: String, description: String? = nil, date: Date? = nil, address: String? = nil, longitute: Double? = nil, latitude: Double? = nil, maxNumberOfAttendence: Int? = nil, attentedUsers: [User]? = nil, type: EventType? = nil) {
        self.title = title
        self.description = description
        self.date = date
        self.address = address
        self.longitute = longitute
        self.latitude = latitude
        self.maxNumberOfAttendence = maxNumberOfAttendence
        self.attentedUsers = attentedUsers
        self.type = type
        self.uid = UUID().uuidString
    }
    
    func isAttending(userId: String?) -> Bool {
        self.attentedUsers?.contains(where: {$0.uid == userId}) ?? false
    }
}

enum EventType: String, Codable, CaseIterable {
    case sport
    case gaming
    case boardGame
    case karaoke
    case other
    
    var title: String {
        switch self {
        case .sport:
            return "Sports"
        case .gaming:
            return "Gaming"
        case .boardGame:
            return "Board Games"
        case .karaoke:
            return "Karaoke"
        case .other:
            return "Other"
        }
    }
    
    var image: UIImage {
        switch self {
        case .sport:
            return UIImage(resource: .sportIcon)
        case .gaming:
            return UIImage(resource: .gamingIcon)
        case .boardGame:
            return UIImage(resource: .boardIcon)
        case .karaoke:
            return UIImage(resource: .karaokeIcon)
        case .other:
            return UIImage(resource: .sportIcon)
        }
    }
}

enum EventFilter: CaseIterable {
    case allEvent
    case attendingEvents
    case sport
    case gaming
    case boardGame
    case karaoke
    case other
    
    var title: String {
        switch self {
        case .allEvent:
            return "All Events"
        case .attendingEvents:
            return "My Attending Events"
        case .sport:
            return "Sport"
        case .gaming:
            return "Gaming"
        case .boardGame:
            return "Board Games"
        case .karaoke:
            return "Karaoke"
        case .other:
            return "Other"
        }
    }
    
    var connectedTypes: [EventType] {
        switch self {
        case .allEvent, .attendingEvents:
            return EventType.allCases
        case .sport:
            return [.sport]
        case .gaming:
            return [.gaming]
        case .boardGame:
            return [.boardGame]
        case .karaoke:
            return [.karaoke]
        case .other:
            return [.other]
        }
    }
}
