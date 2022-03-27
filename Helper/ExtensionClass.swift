//
//  ExtensionClass.swift
//  RSAGrocery
//
//  Created by Weenggs Technology on 09/02/19.
//  Copyright © 2019 Weenggs Technology. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}
