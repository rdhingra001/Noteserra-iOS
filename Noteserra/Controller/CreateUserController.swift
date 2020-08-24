//
//  CreateUserController.swift
//  Noteserra
//
//  Created by  Ronit D. on 8/23/20.
//  Copyright © 2020 Ronit Dhingra Inc. All rights reserved.
//

import UIKit
import Firebase

class CreateUserController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
        addToolbar()
    }
    
    
    func setupElements() {
        
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
        
        // Style the user elements
        Utilities.styleTextField(firstNameField)
        Utilities.styleTextField(lastNameField)
        Utilities.styleTextField(emailField)
        Utilities.styleTextField(passwordField)
        Utilities.styleFilledButton(signUpButton)
        
        // Add the @objc func to the button
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    func addToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.isTranslucent = true
        
        // Bar Button for toolbar
        let dismissBtn = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissButton))
        toolbar.setItems([dismissBtn], animated: true)
        
        // Assign toolbar
        firstNameField.inputAccessoryView = toolbar
        lastNameField.inputAccessoryView = toolbar
        emailField.inputAccessoryView = toolbar
        passwordField.inputAccessoryView = toolbar
    }
    
    @objc private func dismissButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // Validate the fields
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields"
        }
        
        // Validate the user input fields
        let cleanedEmail = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Validation.isEmailValid(cleanedEmail) == false {
            
            // Email isn't valid; show error message
            return "Your email is badly formatted"
        }
        
        if Validation.isPasswordValid(cleanedPassword) == false {
            
            // Password does not meet validation check; show error message
            return "Please make sure that your password is at least 8 characters long."
        }
        
        return nil
    }
    
    public func showAlert(title: String?, message: String?, type: UIAlertController.Style, actionText: String) {
        let ok = UIAlertAction(title: actionText, style: .cancel, handler: nil)
        UIAlertService.showAlert(style: type, title: title, message: message, actions: [ok], completion: nil)
    }
    
    @objc fileprivate func didTapSignUp(_ sender: Any) {
        let error = validateFields()
        guard error == nil else {
            showAlert(title: "Error", message: error, type: .alert, actionText: "OK")
            return
        }
        
        // Create cleaned versions of the inputs
        let firstName = firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, aErr) in
            
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
            
            // Cache the user info so they can be re-referenced for additional setup
            UserDefaults.standard.setValue(firstName, forKey: "firstName")
            UserDefaults.standard.setValue(lastName, forKey: "lastName")
            UserDefaults.standard.setValue(email, forKey: "email")
            UserDefaults.standard.setValue(result!.user.uid, forKey: "uid")
            
            // Proceed to more setup
            strongSelf.performSegue(withIdentifier: "toSetup", sender: nil)
        }
    }

}
