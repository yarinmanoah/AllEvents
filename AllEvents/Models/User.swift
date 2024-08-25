import Foundation

class User: Codable {
    var uid: String?
    var fullName: String?
    var emailAddress: String?
    var profilePictureURL: URL?
    
    init(uid: String? = nil, fullName: String? = nil, emailAddress: String? = nil, profilePictureURL: URL? = nil) {
        self.uid = uid
        self.fullName = fullName
        self.emailAddress = emailAddress
        self.profilePictureURL = profilePictureURL
    }
    
    func toDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return json as? [String: Any]
        } catch {
            print("Error converting User to dictionary: \(error.localizedDescription)")
            return nil
        }
    }
}
