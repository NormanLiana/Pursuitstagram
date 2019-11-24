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
    let uid: String
    let userName: String?
    let photoURL: String?
    
    init(from user: User) {
        self.email = user.email
        self.uid = user.uid
        self.userName = user.displayName
        self.photoURL = user.photoURL?.absoluteString
    }
    
    init?(from dict: [String:Any], id: String) {
        guard let email = dict["email"] as? String,
        let userName = dict["userName"] as? String,
        let photoURL = dict["photoURL"] as? String else {return nil}
        
        self.email = email
        self.uid = id
        self.userName = userName
        self.photoURL = photoURL
    }
    
    var fieldsDict: [String:Any] {
        return [
            "userName": self.userName ?? "",
            "email": self.email ?? ""
        ]
    }
}
