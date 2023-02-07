import UIKit
import MessageUI
// swiftlint:disable line_length

class AboutViewController: UIViewController {
    let soundState = Configuration.shared
    let descriptionAbout = AboutViewDescription.descriptionAbout + AboutViewDescription.descriptionAboutEnglish
    @IBOutlet weak var stateSound: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func sendEmail(_ sender: Any) {
        configureEmail()

    }

    @IBAction func showAboutAlert(_ sender: Any) {
        showAltert()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stateSound.setOn(soundState.soundState, animated: false)
    }

    func showAltert() {
        let  alert = UIAlertController(title: "Score Counter", message: descriptionAbout, preferredStyle: .actionSheet)
        let alterAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alterAction)
        self.present(alert, animated: true, completion: nil)
    }

    func configureEmail() {
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["rodrigoeduardosilv@gmail.com"])
            composer.setSubject("Feebdback Score Counter")
            composer.setMessageBody("Sua Mensagem", isHTML: false)
           present(composer, animated: true)

        } else {
            let alert = UIAlertController(title: "Score Counter", message: "O email do seu device não está configurado", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }

    }

    @IBAction func changeSoundState(_ sender: UISwitch) {
        soundState.soundState = sender.isOn
    }
}

extension AboutViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            controller.dismiss(animated: true)
            return
        }
        switch result {
        case .cancelled:
            controller.dismiss(animated: true, completion: nil)
            print("email cancelado")
        case .saved:
            controller.dismiss(animated: true)
        case .sent:
            print("email enviado")
            controller.dismiss(animated: true)
        case .failed:
            print("falha ao enviar email")
            controller.dismiss(animated: true)
        @unknown default:
            break
        }
        controller.dismiss(animated: true)
    }
}
