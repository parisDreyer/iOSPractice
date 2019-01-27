//
//  ViewController.swift
//  business-cards
//
//  Created by Luke Dreyer on 1/24/19.
//  Copyright © 2019 LukeDreyer. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var settingsSegueButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    
    var contactInfo = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Data.getDefault(key: Data.TextFields[0])
        if name.count == 0 {
            // go to the settings view to set some values for the user
            settingsSegueButton.sendActions(for: .touchUpInside)
        } else {
            contactButton.setTitle(name, for: .normal)
            contactInfo = Data.buildMessage()
            let qrcode = Data.generateQRCode(data: contactInfo)
            self.view.addSubview(qrcode)
        }
    }
  
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    

    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([])
        let name = Data.getDefault(key: "name")
        mailComposerVC.setSubject("\(name) Would Like to Connect")
        if contactInfo.count == 0 { contactInfo = Data.buildMessage() }
        mailComposerVC.setMessageBody(contactInfo, isHTML: true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(sendMailErrorAlert, animated: false, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func sendContactInfo(_ sender: Any) {
        print("SSFG")
        sendEmailButtonTapped(sender: sender as AnyObject)
    }
    
}

