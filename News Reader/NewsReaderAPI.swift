//
//  NewsReaderAPI.swift
//  News Reader
//
//  Created by user180963 on 10/14/20.
//

import Foundation
import Combine
import KeychainAccess

final class NewsReaderAPI : ObservableObject {
    private static var INSTANCE: NewsReaderAPI? = nil
    
    private static let BASE_URL = "https://inhollandbackend.azurewebsites.net/api"
    
    @Published
    var isAuthenticated = false
    
    private let apiRequestHandler = ApiRequestHandler.getInstance()
    
    private let keychain = Keychain()
    private let accessTokenKeychainKey = "accessToken"
    
    var accessToken: String? {
        get {
            try? keychain.get(accessTokenKeychainKey)
        }
        set(newValue) {
            if(newValue == nil) {
                try? keychain.remove(accessTokenKeychainKey)
                isAuthenticated = false
            } else {
                try? keychain.set(newValue!, key: accessTokenKeychainKey)
                isAuthenticated = true
            }
        }
    }
    
    private init() {
        isAuthenticated = accessToken != nil
    }
    
    static func getInstance() -> NewsReaderAPI {
        let instance = self.INSTANCE ?? NewsReaderAPI()
        self.INSTANCE = instance
        return instance
    }
    
    func getArticles(
        count: Int = 20,
        onSuccess: @escaping (ArticleBatch) -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        let url = URL(string: "\(NewsReaderAPI.BASE_URL)/Articles")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if(accessToken != nil) {
            urlRequest.addValue(accessToken!, forHTTPHeaderField: "x-authtoken")
        }
        
        apiRequestHandler.execute(
            request: urlRequest,
            onSuccess: onSuccess,
            onFailure: onFailure
        )
    }
    
    func login(
        username: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        let url = URL(string: "\(NewsReaderAPI.BASE_URL)/Users/login")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        let parameters = UserCredentials(
            username: username,
            password: password
        )
        
        let encoder = JSONEncoder()
        let body = try? encoder.encode(parameters)
        
        if(body != nil) {
            urlRequest.httpBody = body
        } else {
            return
        }
        
        apiRequestHandler.execute(
            request: urlRequest,
            onSuccess: { (response: LoginResponse) in
                self.accessToken = response.accessToken
                onSuccess()
            },
            onFailure: onFailure
        )
    }
    
    func getImage(
        ofImageUrl imageUrl: URL,
        onSuccess: @escaping (Data) -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        apiRequestHandler.getImage(ofImageUrl: imageUrl, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func logout() {
        accessToken = nil
    }
}
