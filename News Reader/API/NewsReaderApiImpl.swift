import Foundation
import Combine
import KeychainAccess

final class NewsReaderApiImpl : NewsReaderApi {
    private static var INSTANCE: NewsReaderApiImpl? = nil

    private static let BASE_URL = "https://inhollandbackend.azurewebsites.net/api"

    private let apiRequestHandler = ApiRequestHandler.getInstance()

    private let keychain = Keychain()
    private let accessTokenKeychainKey = "accessToken"

    private var accessToken: String? {
        get {
            try? keychain.get(accessTokenKeychainKey)
        }
        set(newValue) {
            if let value = newValue {
                try? keychain.set(value, key: accessTokenKeychainKey)
                isAuthenticated = true
            } else {
                try? keychain.remove(accessTokenKeychainKey)
                isAuthenticated = false
            }
        }
    }

    override private init() {
        super.init()
        isAuthenticated = accessToken != nil
    }

    static func getInstance() -> NewsReaderApi {
        let instance = self.INSTANCE ?? NewsReaderApiImpl()
        self.INSTANCE = instance
        return instance
    }

    override func getArticles(
        onlyLikedArticles: Bool = false,
        onSuccess: @escaping (ArticleBatch) -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        let url = URL(string: "\(NewsReaderApiImpl.BASE_URL)/Articles" + (onlyLikedArticles ? "/liked" : ""))!

        var urlRequest = URLRequest(url: url)
        if let token = accessToken {
            urlRequest.addValue(token, forHTTPHeaderField: "x-authtoken")
        } else if(onlyLikedArticles) {
            /// Logged out users don't have any liked articles, so return an empty list
            onSuccess(ArticleBatch(articles: [], nextId: nil))
            return
        }

        apiRequestHandler.execute(
            request: urlRequest,
            onSuccess: onSuccess,
            onFailure: onFailure
        )
    }
    
    override func getArticlesById(
        id: Int,
        onSuccess: @escaping (ArticleBatch) -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        let url = URL(string: "\(NewsReaderApiImpl.BASE_URL)/Articles/\(id)?count=20")!

        var urlRequest = URLRequest(url: url)
        if let token = accessToken {
            urlRequest.addValue(token, forHTTPHeaderField: "x-authtoken")
        }

        apiRequestHandler.execute(
            request: urlRequest,
            onSuccess: onSuccess,
            onFailure: onFailure
        )
    }

    override func login(
        username: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        let url = URL(string: "\(NewsReaderApiImpl.BASE_URL)/Users/login")!

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

    override func register(
        username: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        let url = URL(string: "\(NewsReaderApiImpl.BASE_URL)/Users/register")!

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
            onSuccess: { (response: RegistrationResponse) in
                if(response.success) {
                    self.login(username: username, password: password, onSuccess: onSuccess, onFailure: onFailure)
                } else {
                    onFailure(.genericError(ApiError(message: response.message)))
                }
            },
            onFailure: onFailure
        )
    }

    override func getImage(
        ofImageUrl imageUrl: URL,
        onSuccess: @escaping (Data) -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        apiRequestHandler.getImage(ofImageUrl: imageUrl, onSuccess: onSuccess, onFailure: onFailure)
    }

    override func logout() {
        accessToken = nil
    }
}
