//
//  LoginRequest.swift
//  News Reader
//
//  Created by user180963 on 10/14/20.
//

import Foundation

struct UserCredentials : Encodable {
    let username: String
    let password: String
    
    enum CodingKeys : String, CodingKey {
        case username = "UserName"
        case password = "Password"
    }
}
