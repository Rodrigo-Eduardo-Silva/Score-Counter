import UIKit
import MessageUI
// swiftlint:disable line_length

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func sendEmail(_ sender: Any) {
        let viewController = configureEmail()
        present(viewController, animated: true, completion: nil)
    }

    func configureEmail() -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.setToRecipients(["rodrigoeduardosilv@gmail.com"])
        composer.setSubject("Feebdback Score Counter")
        composer.setMessageBody("Sua Mensagem", isHTML: false)
        return composer
    }
}

extension AboutViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            navigationController?.popViewController(animated: true)
        case .saved:
            navigationController?.popViewController(animated: true)
        case .sent:
            print("email enviado")
        case .failed:
            print("falha ao enviar email")
        @unknown default:
            break
        }
    }
}
