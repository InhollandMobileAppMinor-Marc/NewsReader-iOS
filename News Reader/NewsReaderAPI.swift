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
    
    @Published
    var isAuthenticated = false
    
    private let keychain = Keychain()
    private let accessTokenKeychainKey = "accessToken"
    
    private var cancellable: AnyCancellable?
    
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
    
    func login(
        username: String,
        password: String,
        completion: @escaping (Result<LoginResponse, RequestError>) -> Void
    ) {
        let url = URL(string: "https://inhollandbackend.azurewebsites.net/api/Users/login")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        let parameters = LoginRequest(
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
        
        cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished: break
                case .failure(let error):
                    switch error {
                    case let urlError as URLError:
                        completion(.failure(.urlError(urlError)))
                    case let decodingError as DecodingError:
                        completion(.failure(.decodingError(decodingError)))
                    default:
                        completion(.failure(.genericError(error)))
                    }
                }
            }, receiveValue: { (response) in
                completion(.sccess(response))
            })
    }
    
    func logout() {
        accessToken = nil
    }
}
