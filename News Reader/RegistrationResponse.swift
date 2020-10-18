//
//  RegistrationResponse.swift
//  News Reader
//
//  Created by user180963 on 10/18/20.
//

import Foundation

struct RegistrationResponse : Decodable {
    let success: Bool
    let message: String
    
    enum CodingKeys : String, CodingKey {
        case success = "Success"
        case message = "Message"
    }
}
