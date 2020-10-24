import Foundation

struct LoginResponse : Decodable {
    let accessToken: String

    enum CodingKeys : String, CodingKey {
        case accessToken = "AuthToken"
    }
}
