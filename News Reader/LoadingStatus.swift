//
//  LoadingStatus.swift
//  News Reader
//
//  Created by user180963 on 18/10/2020.
//

import Foundation

enum LoadingStatus<T, ErrorType> {
    case loading
    case loaded(T)
    case error(ErrorType)
}
