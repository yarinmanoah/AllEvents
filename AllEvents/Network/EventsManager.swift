import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Foundation


class EventsManager {
    var ref: DatabaseReference
    
    init() {
        ref = Database.database().reference()
    }
    
    func createEvent(event: Event, completion: (() -> Void)?) {
        let eventId = event.uid
        if let encodedEvent = try? JSONEncoder().encode(event),
           let eventDictionary = try? JSONSerialization.jsonObject(with: encodedEvent) as? [String: Any] {
            self.ref.child("events").child(eventId).setValue(eventDictionary)
            completion?()
        }
    }
    
    func getEvents(completion: (([Event]) -> Void)?) {
        self.ref.child("events").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                print("Error: Could not cast snapshot to dictionary.")
                return
            }
            
            var events: [Event] = []
            
            for (_, eventDict) in value {
                if let eventData = try? JSONSerialization.data(withJSONObject: eventDict),
                   let event = try? JSONDecoder().decode(Event.self, from: eventData),
                   let date = event.date {
                    if date > Date() {
                        events.append(event)
                    }
                }
            }
            
            completion?(events)
        })
    }
    
    func attendToEvent(user: User, eventId: String, completion: ((Bool) -> Void)?) {
        let attentedUsersRef = self.ref.child("events").child(eventId).child("attentedUsers")
        attentedUsersRef.runTransactionBlock( { (currentData: MutableData) -> TransactionResult in
            if var usersArray = currentData.value as? [[String: Any]] {
                if !usersArray.contains(where: { $0["uid"] as? String == user.uid }) {
                    if let userDict = user.toDictionary() {
                        usersArray.append(userDict)
                        currentData.value = usersArray
                    }
                }
            } else {
                if let userDict = user.toDictionary() {
                    currentData.value = [userDict]
                }
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if error != nil {
                completion?(false)
            } else {
                completion?(true)
            }
        }
    }
    
    func unattendEvent(user: User, eventId: String, completion: ((Bool) -> Void)?) {
        let attentedUsersRef = self.ref.child("events").child(eventId).child("attentedUsers")
        
        attentedUsersRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var usersArray = currentData.value as? [[String: Any]] {
                usersArray.removeAll { userDict in
                    return userDict["uid"] as? String == user.uid
                }
                currentData.value = usersArray
            } else {
                //currentData.value = []
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                completion?(false)
            } else {
                completion?(true)
            }
        }
    }
}
