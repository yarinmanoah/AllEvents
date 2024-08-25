import Lottie
import UIKit

extension UIViewController {
    
    private var loadingContainerView: UIView {
        let containerView = UIView(frame: self.view.bounds)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let animationView = LottieAnimationView(name: "loading_animation")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.center = containerView.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        
        containerView.addSubview(animationView)
        animationView.play()
        
        return containerView
    }
    
    func showLoadingAnimation() {
        let containerView = loadingContainerView
        self.view.addSubview(containerView)
    }
    
    func hideLoadingAnimation() {
        for subview in self.view.subviews {
            if let animationView = subview as? LottieAnimationView {
                animationView.stop()
                subview.removeFromSuperview()
            } else if subview.subviews.contains(where: { $0 is LottieAnimationView }) {
                subview.removeFromSuperview()
            }
        }
    }
}
