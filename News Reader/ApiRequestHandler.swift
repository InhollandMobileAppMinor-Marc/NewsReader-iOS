//
//  ApiRequestHandler.swift
//  News Reader
//
//  Created by user180963 on 10/18/20.
//

import Foundation
import Combine

final class ApiRequestHandler {
    private static var INSTANCE: ApiRequestHandler? = nil
    
    private var cancellable: AnyCancellable?
    
    private init() {}
    
    static func getInstance() -> ApiRequestHandler {
        let instance = self.INSTANCE ?? ApiRequestHandler()
        self.INSTANCE = instance
        return instance
    }
    
    func execute<ResponseType : Decodable>(
        request: URLRequest,
        onSuccess: @escaping (ResponseType) -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: ResponseType.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished: break
                case .failure(let error): onFailure(ApiRequestHandler.mapErrorToRequestError(error))
                }
            }) { response in
                onSuccess(response)
            }
    }
    
    func getImage(
        ofImageUrl imageUrl: URL,
        onSuccess: @escaping (Data) -> Void,
        onFailure: @escaping (RequestError) -> Void
    ) {
        let urlRequest = URLRequest(url: imageUrl)
        
        cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break
                case .failure(let error): onFailure(ApiRequestHandler.mapErrorToRequestError(error))
                }
            }) { response in
                onSuccess(response)
            }
    }
    
    private static func mapErrorToRequestError(_ error: Error) -> RequestError {
        switch error {
        case let urlError as URLError:
            return .urlError(urlError)
        case let decodingError as DecodingError:
            return .decodingError(decodingError)
        default:
            return .genericError(error)
        }
    }
}
