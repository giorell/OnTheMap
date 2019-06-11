//
//  UdacityPostResponse.swift
//  On The Map
//
//  Created by Giordany Orellana on 3/3/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import Foundation

//{"objectId":"4aGtOQfIqh","createdAt":"2019-03-03T15:44:52.165Z"}
struct postResponse: Codable {
    
    let objectId: String
    let createdAt: String
    
    enum Codingkeys: String, CodingKey {
        case objectID = "objectId"
        case createdAt = "createdAt"
    }
}
