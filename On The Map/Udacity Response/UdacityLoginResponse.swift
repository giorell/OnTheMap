//
//  UdacityLoginResponse.swift
//  On The Map
//
//  Created by Giordany Orellana on 2/22/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    let account: AccountStruct
    let session: SessionStruct
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case session = "session"
    }
}

struct AccountStruct: Codable {
    let registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case registered = "registered"
        case key = "key"
    }
}

struct SessionStruct: Codable {
    let id: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case expiration = "expiration"
    }
}
