import UIKit

extension UIView {
    var currentFirstResponder: UIResponder? {
        if isFirstResponder {
            return self
        }
        for subview in subviews {
            if let firstResponder = subview.currentFirstResponder {
                return firstResponder
            }
        }
        return nil
    }
}
