import Foundation

enum RequestError : Error {
    case urlError(URLError)
    case decodingError(DecodingError)
    case genericError(Error)
}
