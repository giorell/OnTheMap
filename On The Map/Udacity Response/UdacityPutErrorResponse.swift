//
//  UdacityPutErrorResponse.swift
//  On The Map
//
//  Created by Giordany Orellana on 3/6/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import Foundation

struct UdacityPutErrorResponse: Codable {
    
    let code: Int
    let error: String
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case error = "error"
    }
}

extension UdacityPutErrorResponse: LocalizedError {
    
    var errorDescription: String? {
        return error
    }
}

