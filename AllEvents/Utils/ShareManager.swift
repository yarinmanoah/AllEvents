import MessageUI
import UIKit

private enum ShareOption: CaseIterable {
    case email
    case sms
    case whatsapp
    
    var title: String {
        switch self {
        case .email:
            return "Share with Email"
        case .sms:
            return "Share with SMS"
        case .whatsapp:
            return "Share with Whatsapp"
        }
    }
}

class ShareManager {
    private static func createShareBody(event: Event) -> String {
        """
        Hey,
        Check out this cool event: \(event.title)
        Here's some details: \(event.description ?? ""),
        will occure on  \(event.date?.formatted() ?? ""), in this address: \(event.address ?? "").
        currently attending: \(event.attentedUsers?.count ?? 0)/\(event.maxNumberOfAttendence ?? 0).
        Check All Events App to join us.
        """
    }
    
    static func startShareFlow(presentingVC: UIViewController?, event: Event) {
        guard let presentingVC = presentingVC else { return }
        let content = createShareBody(event: event)
        let activityViewController = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        presentingVC.present(activityViewController, animated: true, completion: nil)
    }
}
