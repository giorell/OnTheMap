//
//  UdacityStudentLocationResponse.swift
//  On The Map
//
//  Created by Giordany Orellana on 2/19/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import Foundation

struct StudentLocationResponse: Codable {
    
    let objectId: String?
    let mediaURL: String?
    let firstName: String?
    let longitude: Double?
    let uniqueKey: String?
    let latitude: Double?
    let mapString: String?
    let lastName: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        
        case objectId = "objectId"
        case mediaURL = "mediaURL"
        case firstName = "firstName"
        case longitude = "longitude"
        case uniqueKey = "uniqueKey"
        case latitude = "latitude"
        case mapString = "mapString"
        case lastName = "lastName"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
}
