//
//  ArticleBatch.swift
//  News Reader
//
//  Created by user180963 on 10/18/20.
//

import Foundation

struct ArticleBatch : Decodable {
    let articles: [Article]
    let nextId: Int?
    
    enum CodingKeys : String, CodingKey {
        case articles = "Results"
        case nextId = "NextId"
    }
}
