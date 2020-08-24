//
//  SetupViewController.swift
//  Noteserra
//
//  Created by  Ronit D. on 8/24/20.
//  Copyright © 2020 Ronit Dhingra Inc. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var carnivalAppIcon: UIButton!
    @IBOutlet weak var carnivalAppIconLabel: UILabel!
    @IBOutlet weak var chillOceanAppIcon: UIButton!
    @IBOutlet weak var chillOceanAppIconLabel: UILabel!
    @IBOutlet weak var fiestaAppIcon: UIButton!
    @IBOutlet weak var fiestaAppIconLabel: UILabel!
    @IBOutlet weak var jungleGreenAppIcon: UIButton!
    @IBOutlet weak var jungleGreenAppIconLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
    }
    
    func setupElements() {
        
        // Styling the elements
        Utilities.styleTextField(dobField)
        Utilities.styleTextField(usernameField)
        Utilities.styleFilledButton(finishButton)
        
        // Change the welcome label to show the user's name
        let firstName = UserDefaults.standard.value(forKey: "firstName") as! String
        welcomeLabel.text = "Hey, \(firstName)"
        
        // Setting the image backrground to match the elements
        let background = UIImage(named: "background")
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
}
