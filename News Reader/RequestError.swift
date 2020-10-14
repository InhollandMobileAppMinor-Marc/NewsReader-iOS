//
//  RequestError.swift
//  News Reader
//
//  Created by user180963 on 10/14/20.
//

import Foundation

enum RequestError : Error {
    case urlError(URLError)
    case decodingError(DecodingError)
    case genericError(Error)
}
