import UIKit
import MessageUI

class AboutViewController: UIViewController {

    var controller =  MFMessageComposeViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sendEmail(_ sender: Any) {
        present(controller, animated: true, completion: nil)
    }

}
