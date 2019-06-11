//
//  UdacityStudentLocationResults.swift
//  On The Map
//
//  Created by Giordany Orellana on 2/23/19.
//  Copyright © 2019 Giordany Orellana. All rights reserved.
//

import Foundation

struct UdacityStudentLocationResults: Codable {
    let results: [StudentLocationResponse]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
