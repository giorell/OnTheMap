//
//  UserStudentInformation.swift
//  On The Map
//
//  Created by Giordany Orellana on 2/24/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import Foundation

struct UserStudentInfo: Codable {
    
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: String
    var longitude: String
    
    enum CodingKeys: String, CodingKey {
        
        case uniqueKey = "uniqueKey"
        case firstName = "firstName"
        case lastName = "lastName"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
