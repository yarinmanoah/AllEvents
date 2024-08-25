import UIKit

class ParticipantsSummaryView: UIView {
    @IBOutlet weak var numberOfParticipantsLabel: UILabel!
    @IBOutlet weak var participantsStackView: UIStackView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "ParticipantsSummaryView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    func configure(event: Event?) {
        let attentedUsers = event?.attentedUsers?.count ?? 0
        let maxAttentence = event?.maxNumberOfAttendence ?? 0
        self.numberOfParticipantsLabel.text = "(\(attentedUsers)/\(maxAttentence))"
        
        event?.attentedUsers?.compactMap { $0 }.forEach { user in
            let view = ParticipantView()
            view.configure(user: user)
            self.participantsStackView.addArrangedSubview(view)
        }
    }
}
