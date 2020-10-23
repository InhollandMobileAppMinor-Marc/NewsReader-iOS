//
//  FakeNewsReaderApi.swift
//  News Reader
//
//  Created by user180963 on 21/10/2020.
//

import Foundation

final class FakeNewsReaderApi : NewsReaderApi {
    private static var INSTANCE: FakeNewsReaderApi? = nil
    
    static var article = Article(
        id: 1,
        feed: 1,
        title: "Hello world!",
        summary: "Lorem ipsum",
        publishDate: "2020-10-19T12:00",
        image: URL(string: "https://marketplace.canva.com/MAB_ajIqclg/1/0/thumbnail_large/canva-hello-world-instagram-post-MAB_ajIqclg.jpg")!,
        url: URL(string: "https://example.com/")!,
        related: [],
        categories: [],
        isLiked: false
    )
    
    override private init() {
        super.init()
    }
    
    static func getInstance() -> NewsReaderApi {
        let instance = self.INSTANCE ?? FakeNewsReaderApi()
        self.INSTANCE = instance
        return instance
    }
    
    override func getArticles(
        onlyLikedArticles: Bool = false,
        onSuccess: @escaping (ArticleBatch) -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        onSuccess(ArticleBatch(
            articles: (!onlyLikedArticles || FakeNewsReaderApi.article.isLiked ? [FakeNewsReaderApi.article] : []),
            nextId: nil
        ))
    }
    
    override func login(
        username: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        isAuthenticated = true
        onSuccess()
    }
    
    override func register(
        username: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        isAuthenticated = true
        onSuccess()
    }
    
    override func getImage(
        ofImageUrl imageUrl: URL,
        onSuccess: @escaping (Data) -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        // N/A
    }
    
    override func logout() {
        isAuthenticated = false
    }
}
