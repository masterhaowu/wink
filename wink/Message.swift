//
//  Message.swift
//  wink
//
//  Created by Hao Wu on 6/4/17.
//  Copyright © 2017 Hao Wu. All rights reserved.
//

import UIKit;
import Firebase;

class Message: NSObject {

    var text: String?;
    var fromID: String?;
    var toID: String?;
    var timestamp: Int?;
    
    
    func chatPartnerID() -> String? {
        
        if fromID == Auth.auth().currentUser?.uid {
            return toID;
        } else {
            return fromID;
        }
        
    }
    
}
