//
//  UdacityErrorResponse.swift
//  On The Map
//
//  Created by Giordany Orellana on 2/22/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import Foundation

struct UdacityErrorResponse: Codable {
    
    let status: Int
    let error: String
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case error = "error"
    }
}

extension UdacityErrorResponse: LocalizedError {
    
    var errorDescription: String? {
        return error
    }
}
