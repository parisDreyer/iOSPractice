//
//  ViewController_CardStylesEXT.swift
//  business-cards
//
//  Created by Luke Dreyer on 1/25/19.
//  Copyright © 2019 LukeDreyer. All rights reserved.
//

import Foundation
import UIKit

class Data {
    public static let TextFields = [
        "name",
        "email",
        "phone",
        "portfolio",
        "github",
        "linkedin"
    ]
    static func getDefault(key: String) -> String {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: key) ?? ""
    }
    
    @objc static func setDefaults(sender: UITextField){ // key: String, value: String
        if(sender.tag >= 0 && sender.tag < Data.TextFields.count){
            let key = Data.TextFields[sender.tag]
            let value = sender.text
            let defaults = UserDefaults.standard
            defaults.set(value, forKey: key)
        }
    }

    static func setBackgroundColor(context: UIViewController, r: Float, b: Float, g: Float, a: Float) {
        let color = UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: 1.0)
        context.view.backgroundColor = color
    }
    static func buildMessage() -> String{
        var content = "<p>"
        let name = Data.getDefault(key: "name")
        let email = Data.getDefault(key: "email")
        let phone = Data.getDefault(key: "phone")
        let profile = Data.getDefault(key: "profile")
        let linkedin = Data.getDefault(key: "linkedin")
        let github = Data.getDefault(key: "github")
        
        if name.count > 0 { content += "<h1>\(name)</h1><br/>" }
        if email.count > 0 { content += "<h3>\(email)</h3><br/>" }
        if phone.count > 0 { content += "<h3>\(phone)</h3><br/>" }
        if profile.count > 0 { content += "<h3>\(profile)</h3><br/>" }
        if linkedin.count > 0 { content += "<h3>\(linkedin)</h3><br/>" }
        if github.count > 0 { content += "<h3>\(github)</h3><br/>" }
        
        content += "</p>"
        return content
        //"<p><h1>Luke Dreyer</h1><ul><li>lukepdreyer@gmail.com</li><li>http://www.lukeparisdreyer.space</li><li>https://www.linkedin.com/in/lukepdreyer/</li><li>https://github.com/parisDreyer</li></ul></p>"
    }
    
    static func generateQRCode(data: String) -> QRCodeView{
        let frame = CGRect(origin: CGPoint(x: 56, y: 283), size: .init(width: 263, height: 263))
        let view = QRCodeView(frame: frame)
        view.generateCode(data)
        return view
    }
}
