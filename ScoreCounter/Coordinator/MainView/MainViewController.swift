import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func showGamesViewController(view: UIView)
}

class MainViewController: UIViewController {
    var delegate: MainViewControllerDelegate?
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        delegate?.showGamesViewController(view: view)
       
    }
}
