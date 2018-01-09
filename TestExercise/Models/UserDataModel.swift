//
//  UserDataModel.swift
//  TestExercise
//
//  Created by Admin on 05.01.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class UserDataModel : SavedUserDataProtocol {
    var id: Int?
    var name: String?
    var username: String?
    var phone: String?
    var latitude: Double?
    var longitude: Double?
    var comment: String? = ""
    
    init(id : Int, name : String, username : String, phone : String, latitude : Double, longitude : Double, comment : String) {
        self.id = id
        self.name = name
        self.username = username
        self.latitude = latitude
        self.longitude = longitude
        self.phone = phone
        self.comment = comment
    }
}
