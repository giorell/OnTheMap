//
//  UdacityUpdateResponse.swift
//  On The Map
//
//  Created by Giordany Orellana on 3/7/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import Foundation


struct updateResponse: Codable {
    
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case updatedAt = "updatedAt"
    }
}
