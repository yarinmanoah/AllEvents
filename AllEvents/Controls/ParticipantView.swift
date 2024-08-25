import UIKit

class ParticipantView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "ParticipantView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.contentMode = .scaleToFill
        self.imageView.layer.borderWidth = 0.5
        self.imageView.layer.borderColor = UIColor.purple.cgColor
        self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        self.imageView.clipsToBounds = true
    }
    
    func configure(user: User) {
        if let url = user.profilePictureURL {
            self.imageView.loadImage(from: url)
        } else {
            self.imageView.image = UIImage(resource: .uploadProfile)
        }
        
        nameLabel.text = user.fullName
    }
}
