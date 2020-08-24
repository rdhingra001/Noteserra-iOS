//
//  AuthViewController.swift
//  Noteserra
//
//  Created by  Ronit D. on 8/24/20.
//  Copyright © 2020 Ronit Dhingra Inc. All rights reserved.
//

import UIKit
import Firebase
import SwiftHEXColors

class AuthViewController: UIViewController {
    
    // Create an enumeration to help reference our tab indexes
    enum TabIndex: Int {
        case firstTab = 0
        case secondTab = 1
        case thirdTab = 2
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var authSegements: UISegmentedControl!
    
    // Initialize our views from the controllers
    var currentVC: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInVC")
        return vc
    }()
    lazy var secondChildTabVC: UIViewController? = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
        return vc
    }()
    lazy var getStartedTabVC: UIViewController? = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GetStartedVC")
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the default value for our current controller
        currentVC = GetStartedViewController()
    
        
        // Change the font color of segmented control
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        authSegements.setTitleTextAttributes(titleTextAttributes, for: .normal)
        authSegements.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if currentVC != nil {
            currentVC!.viewWillDisappear(animated)
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.firstTab.rawValue:
            vc = firstChildTabVC
        case TabIndex.secondTab.rawValue:
            vc = secondChildTabVC
        case TabIndex.thirdTab.rawValue:
            vc = getStartedTabVC
        default:
            return nil
        }
        
        return vc
    }
    
    func displayCurrentTab(_ tabIndex: Int) {
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentVC = vc
        }
    }
    
    @IBAction func didSwitchAuthSegments(_ sender: UISegmentedControl) {
        self.currentVC!.view.removeFromSuperview()
        self.currentVC!.removeFromParent()
        displayCurrentTab(sender.selectedSegmentIndex)
        
        if sender.selectedSegmentIndex == 2 {
            sender.setEnabled(true, forSegmentAt: 0)
            sender.setEnabled(true, forSegmentAt: 1)
        }
        
        view.backgroundColor = .init(red: 224/255, green: 31/255, blue: 66/255, alpha: 1)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
