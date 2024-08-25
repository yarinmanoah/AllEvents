import UIKit

class LoginViewController: AllEventsScrollableBaseViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.emailTextField.delegate = self
        self.emailErrorLabel.isHidden = true
        self.passwordTextField.delegate = self
        self.passwordErrorLabel.isHidden = true
    }
    
    private func validateInput(email: String, password: String) -> Bool {
        var isEmailValid: Bool = false
        var isPasswordValid: Bool = false
        
        if email.isValidEmail {
            isEmailValid = true
            self.emailErrorLabel.isHidden = true
        } else {
            self.emailErrorLabel.isHidden = false
        }
        
        if password.count >= 8 {
            isPasswordValid = true
            self.passwordErrorLabel.isHidden = true
        } else {
            self.passwordErrorLabel.isHidden = false
        }
        
        return isEmailValid && isPasswordValid
    }
    
    private func showEventsScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let eventsVC = storyboard.instantiateViewController(withIdentifier: "EventsListViewController") as? EventsListViewController {
            self.navigationController?.pushViewController(eventsVC, animated: true)
        }
    }
    
    @IBAction func onLoginButtonPressed(_ sender: Any) {
        guard let email = self.emailTextField.text,
              let password = self.passwordTextField.text,
              self.validateInput(email: email, password: password) else { return }
        
        showLoadingAnimation()
        SignInManager().signIn(
            email: email,
            password: password,
            onError:  { [weak self] in
                guard let self else { return }
                self.hideLoadingAnimation()
                self.showAlert(text: "Email or Password are wrong, please try again.")
            }
        ) { [weak self] user in
            guard let self else { return }
            SessionManager.shared.user = user
            self.hideLoadingAnimation()
            self.showEventsScreen()
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            return self.passwordTextField.becomeFirstResponder()
        } else {
            self.passwordTextField.resignFirstResponder()
            self.onLoginButtonPressed(textField)
        }
        return true
    }
}
