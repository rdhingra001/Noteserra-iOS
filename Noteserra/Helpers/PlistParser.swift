//
//  PlistParser.swift
//  DearDiary
//
//  Created by  Ronit D. on 7/25/20.
//  Copyright © 2020 Ronit Dhingra. All rights reserved.
//

import Foundation

struct PlistParser {
    
    static func getStringValue(_ forKey: String) -> String {
        guard let value = Bundle.main.infoDictionary?[forKey] as? String else {
            fatalError("No value found for key \(forKey)")
        }
        return value
    }
}
