//
//  LoginResponse.swift
//  LeagueiOSChallenge
//
//  Copyright © 2024 League Inc. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let apiKey: String
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}
