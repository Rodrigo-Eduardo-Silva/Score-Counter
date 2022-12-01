import UIKit
import MessageUI

class ServiceEmail {
    let controller: MFMessageComposeViewController?
    init(controller: MFMessageComposeViewController) {
        self.controller = controller
    }

    func contactUs() {
        let emailViewController = controller
    }

}
