//
//  Feed.swift
//  News Reader
//
//  Created by user180963 on 10/18/20.
//

import Foundation

struct Feed : Decodable, Identifiable {
    let id: Int
    let name: String
    
    enum CodingKeys : String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}
