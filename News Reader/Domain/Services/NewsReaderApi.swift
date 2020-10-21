//
//  NewsReaderApi.swift
//  News Reader
//
//  Created by user180963 on 21/10/2020.
//

import Foundation

class NewsReaderApi : ObservableObject {
    @Published
    var isAuthenticated = false
    
    internal init() {}
    
    func getArticles(
        count: Int = 20,
        onSuccess: @escaping (ArticleBatch) -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {}
    
    func login(
        username: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {}
    
    func getImage(
        ofImageUrl imageUrl: URL,
        onSuccess: @escaping (Data) -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {}
    
    func logout() {}
}
