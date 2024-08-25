import UIKit

protocol FilterViewDelegate: AnyObject {
    func filterViewDidSelectFilter(_ filterView: FilterView, filter: EventFilter)
}

class FilterView: UIView {

    @IBOutlet weak var filterValueLabel: UILabel!
    
    weak var delegate: FilterViewDelegate?
    
    private var presentingVC: UIViewController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "FilterView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    
    @IBAction func onFilterPressed(_ sender: Any) {
        let actionSheetController = UIAlertController(title: "", message: "Choose an event type to filter by", preferredStyle: .actionSheet)

        EventFilter.allCases.forEach { filter in
            let action = UIAlertAction(title: filter.title, style: .default) { _ in
                self.filterValueLabel.text = filter.title
                self.delegate?.filterViewDidSelectFilter(self, filter: filter)
                
            }
            actionSheetController.addAction(action)
        }
        
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            actionSheetController.dismiss(animated: true)
        }))
        
        self.presentingVC?.present(actionSheetController, animated: true, completion: nil)
    }
    
    func configure(filter: EventFilter, presentingVC: UIViewController) {
        self.presentingVC = presentingVC
        self.filterValueLabel.text = filter.title
    }
}
