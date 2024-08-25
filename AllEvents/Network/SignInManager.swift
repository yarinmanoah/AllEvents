import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit

class SignInManager {
    var ref: DatabaseReference
    
    init() {
        ref = Database.database().reference()
    }
    
    private func completeSignUp(email: String , password: String, name: String, imageUrl: URL? = nil, completion: (() -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
            if let error {
                print(error.localizedDescription)
            } else {
                guard let user = authResult?.user else { return }
                
                let userId = user.uid
                let userObject = User(
                    uid: userId,
                    fullName: name,
                    emailAddress: email,
                    profilePictureURL: imageUrl
                )
                
                if let encodedUser = try? JSONEncoder().encode(userObject),
                   let userDictionary = try? JSONSerialization.jsonObject(with: encodedUser) as? [String: Any] {
                    self.ref.child("users").child(userId).setValue(userDictionary)
                    completion?()
                }
            }
        })
    }
    
    func signUp(email: String , password: String, name: String, profileImage: UIImage?, completion: (() -> Void)?) {
        if let profileImage,
           let imageData = profileImage.jpegData(compressionQuality: 0.75) {
            let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        return
                    }
                    guard let downloadURL = url else { return }
                    self.completeSignUp(email: email, password: password, name: name, imageUrl: downloadURL, completion: completion)
                }
            }
        } else {
            completeSignUp(email: email, password: password, name: name, completion: completion)
        }
    }
    
    func signIn(email: String, password: String, onError: (() -> Void)?, completion: ((User) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
            if let error {
                onError?()
            } else {
                guard let user = authResult?.user else { return }
                let userID = user.uid
                self.ref.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value else { return }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value)
                        let userObject = try JSONDecoder().decode(User.self, from: jsonData)
                        completion?(userObject)
                        print("User object: \(userObject)")
                    } catch {
                        onError?()
                    }
                })
            }
        })
    }
}
