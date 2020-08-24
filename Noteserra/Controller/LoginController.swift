//
//  ViewController.swift
//  Noteserra
//
//  Created by  Ronit D. on 8/23/20.
//  Copyright © 2020 Ronit Dhingra Inc. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        addToolbar()
    }
    
    func addToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.isTranslucent = true
        
        // Bar Button for toolbar
        let dismissBtn = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissButton))
        toolbar.setItems([dismissBtn], animated: true)
        
        // Assign toolbar
        emailField.inputAccessoryView = toolbar
        passwordField.inputAccessoryView = toolbar
    }
    
    @objc func dismissButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    fileprivate func setupElements() {
        
        // Style the elements
        Utilities.styleTextField(emailField)
        Utilities.styleTextField(passwordField)
        Utilities.styleFilledButton(signInButton)
        
        // Add the @objc func to the button
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        // Assign the background to be custom image
        let background = UIImage(named: "background")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // Validate the fields
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields"
        }
        
        // Validate the user input fields
        let cleanedEmail = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Validation.isEmailValid(cleanedEmail) == false {
            
            // Email isn't valid; show error message
            return "Your email is badly formatted"
        }
        
        
        return nil
    }
    
    public func showAlert(title: String?, message: String?, type: UIAlertController.Style, actionText: String) {
        let ok = UIAlertAction(title: actionText, style: .cancel, handler: nil)
        UIAlertService.showAlert(style: type, title: title, message: message, actions: [ok], completion: nil)
    }
    
    @objc fileprivate func didTapSignIn(_ sender: Any) {
        let error = validateFields()
        guard error == nil else {
            showAlert(title: "Error", message: error, type: .alert, actionText: "OK")
            return
        }
        
        // Create cleaned versions of the inputs
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Ping the Auth backend to log in user
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, aErr) in
            guard let strongSelf = self else { return }
            guard result != nil else {
                debugPrint("Failed to obtain a result")
                return
            }
            guard aErr == nil else {
                if aErr != nil {
                    strongSelf.showAlert(title: "Error", message: "There was an error logging in. Try again later.", type: .alert, actionText: "OK")
                    print(aErr.debugDescription)
                }
                return
            }
            
            strongSelf.performSegue(withIdentifier: "toFeedLogin", sender: nil)
            
        }
    }
    


}

