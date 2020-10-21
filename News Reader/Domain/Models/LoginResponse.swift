//
//  LoginResponse.swift
//  News Reader
//
//  Created by user180963 on 10/14/20.
//

import Foundation

struct LoginResponse : Decodable {
    let accessToken: String
    
    enum CodingKeys : String, CodingKey {
        case accessToken = "AuthToken"
    }
}
