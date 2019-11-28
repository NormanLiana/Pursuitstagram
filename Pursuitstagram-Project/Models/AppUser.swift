//
//  AppUser.swift
//  Pursuitstagram-Project
//
//  Created by Liana Norman on 11/24/19.
//  Copyright © 2019 Liana Norman. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AppUser {
    let email: String?
    let photoURL: String?
    let uid: String
    let userName: String?
    
    
    init(from user: User) {
        self.email = user.email
        self.uid = user.uid
        self.photoURL = user.photoURL?.absoluteString
        self.userName = user.displayName
    }
    
    init?(from dict: [String:Any], id: String) {
        guard let email = dict["email"] as? String,
        let photoURL = dict["photoURL"] as? String,
        let userName = dict["userName"] as? String else {return nil}
        
        self.photoURL = photoURL
        self.email = email
        self.uid = id
        self.userName = userName
        
    }
    
    var fieldsDict: [String:Any] {
        return [
            "userName": self.userName ?? "",
            "email": self.email ?? ""
        ]
    }
}
