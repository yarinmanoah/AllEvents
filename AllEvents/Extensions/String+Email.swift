import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegex = "^\"[^\"]+\"|^[A-Za-z0-9!#%&`_=\\/$\\'*+?^{}|~.-]+@(?!\\.)(?!.*\\.$)(?!.*\\.\\.)[A-Za-z0-9-]+\\.[A-Za-z]{2,64}"
        guard let regex = try? NSRegularExpression(pattern: emailRegex, options: []) else {
            return false
        }
        let range = NSRange(location: 0, length: utf16.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}
