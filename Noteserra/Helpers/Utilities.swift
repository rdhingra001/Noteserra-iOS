//
//  Utilities.swift
//  DearDiary
//
//  Created by Ronit Dhingra on 6/26/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import Foundation
import UIKit

class Utilities: NSObject {
    
    static var defaultProfilePic: UIImage? = UIImage(named: "defaultProfilePicture")
    
    static var customColor: UIColor = UIColor.init(red: 23/255, green: 95/255, blue: 125/255, alpha: 1)
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = customColor.cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = customColor
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    
    static func styleSelecterButton(_ button: UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = customColor
        button.layer.cornerRadius = 5.0
        button.tintColor = UIColor.white
        
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = customColor.cgColor
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
        button.titleLabel?.alpha = 2
    }
    
    static func styleLabel(_ label:UILabel) {
        
        label.textColor = UIColor.init(red: 58/255, green: 134/255, blue: 133/255, alpha: 0.93375)
        label.layer.cornerRadius = 75.0
    
    }
    
    static func styleSetupLabel(_ label:UILabel) {
        
        label.textColor = UIColor.init(red: 48/255, green: 129/255, blue: 143/255, alpha: 0.93275)
        label.layer.cornerRadius = 75.0
        
    }
    
    static func roundenButton(_ button: UIButton) {
        
        button.layer.cornerRadius = 25.0
    }

    
    // Parsing a url and constructing an image from the link
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                guard let strongSelf = self else { return }
                let finishedImage = UIImage(data: data) ?? Utilities.defaultProfilePic
            }
        }
    }
    

}

extension UIView {
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.size.height + frame.origin.y
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.size.width + frame.origin.x
    }
    
}

extension UIColor {
    static func googleRed() -> UIColor {
        return UIColor(red: 220/255, green: 78/255, blue: 65/255, alpha: 1)
    }
    
    static func custom() -> UIColor {
        return UIColor(red: 30/255, green: 125/255, blue: 165/255, alpha: 1)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
            contentMode = mode
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }.resume()
        }
        func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
}

extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}


