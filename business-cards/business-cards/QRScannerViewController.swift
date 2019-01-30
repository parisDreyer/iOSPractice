//
//  QRScannerViewController.swift
//  business-cards
//
//  Created by Luke Dreyer on 1/27/19.
//  Copyright © 2019 LukeDreyer. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        // prep video capture
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        
        // draw green rect ( to guide video capture )
        let half = self.view.frame.size.width / 2
        let qrt = half / 2
        let eighth = qrt / 2
        let layer = CALayer()
        layer.frame = CGRect(x: half - eighth, y: half + eighth, width: qrt, height: qrt);
        layer.borderWidth = 2
        layer.opacity = 1
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderColor = UIColor.green.cgColor
        self.view.layer.addSublayer(layer)
        self.previewLayer = layer as? AVCaptureVideoPreviewLayer
        // end draw green rect
        
        // backbutton if user wants to quit
        let backButton = UIButton(type: .roundedRect) // if you want to set the type use like UIButton(type: .RoundedRect) or UIButton(type: .Custom)
        backButton.setTitle("< back", for: .normal)
        backButton.setTitleColor(UIColor.blue, for: .normal)
        backButton.titleLabel?.minimumScaleFactor = 0.5;
        backButton.titleLabel?.numberOfLines = 0;
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        backButton.backgroundColor = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha:0.2) // light silver bkgrnd
        backButton.layer.cornerRadius = 5   // rounded borders
        backButton.titleLabel?.font = backButton.titleLabel?.font.withSize(28)
        backButton.frame = CGRect(x: 10, y: 15, width: 105, height: 65) // upper left
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.view.addSubview(backButton)
        // end backbutton
        
        // do the camera
        captureSession.startRunning()
    }
    
    // go back to main screen when back button is clicked
    @objc func backAction() -> Void {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Main") as! ViewController // value "Main" is set as StoryBoard_ID:Main in the Identity Section
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
