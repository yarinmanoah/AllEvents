import UIKit

class SignupViewController: AllEventsScrollableBaseViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var fullNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        self.profileImageView.layer.cornerRadius = 75
        self.profileImageView.layer.borderColor = UIColor.black.cgColor
        self.profileImageView.layer.borderWidth = 1.0
        
        self.fullNameTextField.delegate = self
        self.fullNameErrorLabel.isHidden = true
        
        self.emailTextField.delegate = self
        self.emailErrorLabel.isHidden = true
        
        self.passwordTextField.delegate = self
        self.passwordErrorLabel.isHidden = true
    }
    
    private func validateInput(fullName: String, email: String, password: String) -> Bool {
        self.fullNameErrorLabel.isHidden = fullName.count > 2
        self.emailErrorLabel.isHidden = email.isValidEmail
        self.passwordErrorLabel.isHidden = password.count >= 8

        return fullName.count > 2 && email.isValidEmail && password.count >= 8
    }
    

    @IBAction func onProfilePicturePressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
        
    }
    

    @IBAction func onSignupButtonPressed(_ sender: Any) {
        guard let name = self.fullNameTextField.text,
              let email = self.emailTextField.text,
              let password = self.passwordTextField.text,
              self.validateInput(fullName: name, email: email, password: password) else { return }
        
        showLoadingAnimation()
        SignInManager().signUp(
            email: email,
            password: password,
            name: name,
            profileImage: self.profileImage,
            completion: { [weak self] in
                guard let self else { return }
                self.hideLoadingAnimation()
                self.navigationController?.popViewController(animated: true)
            }
        )
    }
}

extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTextField {
            return self.emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            return self.passwordTextField.becomeFirstResponder()
        } else {
            self.passwordTextField.resignFirstResponder()
            onSignupButtonPressed(textField)
        }
        
        return true
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImage = pickedImage
            self.profileImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true)
    }
}
