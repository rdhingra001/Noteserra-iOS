//
//  AuthHUD.swift
//  DearDiary
//
//  Created by  Ronit D. on 7/25/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import Foundation
import JGProgressHUD

enum AuthHudType {
    case none
    case show
    case update
    case success
    case error
}

struct AuthHudInfo {
    let type: AuthHudType
    let text: String
    let detailText: String
}

class AuthHUD {
    
    // MARK: -
    // MARK: Handle hud
    
    static func handle(_ hud: JGProgressHUD, with info: AuthHudInfo) {
        switch info.type {
        case .none:
            return
        case .show:
            show(hud, text: info.text, detailText: info.detailText)
        case .update:
            change(hud, text: info.text, detailText: info.detailText)
        case .success:
            dismiss(hud, type: info.type, text: info.text, detailText: info.detailText)
        case .error:
            change(hud, text: info.text, detailText: info.detailText)
        }
    }
    
    // MARK: -
    // MARK: Create hud
    
    static func create() -> JGProgressHUD {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }
    
    // MARK: -
    // MARK: Show hud
    
    static func show(_ hud: JGProgressHUD, text: String, detailText: String = "") {
        hud.textLabel.text = text
        if detailText != "" {
            hud.detailTextLabel.text = detailText
        }
        if let topVC = UIApplication.getTopMostViewController() {
            hud.show(in: topVC.view)
        }
    }
    
    // MARK: -
    // MARK: Change hud
    
    static func change(_ hud: JGProgressHUD, text: String, detailText: String = "") {
        hud.textLabel.text = text
        if detailText != "" {
            hud.detailTextLabel.text = detailText
        }
    }
    
    // MARK: -
    // MARK: Dismiss hud
    
    static func dismiss(_ hud: JGProgressHUD, type: AuthHudType, text: String, detailText: String) {
        DispatchQueue.main.async {
            hud.textLabel.text = text
            hud.detailTextLabel.text = detailText
            let delay = type == .success ? TimeInterval(0.5) : TimeInterval(1.0)
            hud.dismiss(afterDelay: delay , animated: true)
        }
    }
    
}
