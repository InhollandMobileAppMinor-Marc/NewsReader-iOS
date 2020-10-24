import Foundation

struct UserCredentials : Encodable {
    let username: String
    let password: String

    enum CodingKeys : String, CodingKey {
        case username = "UserName"
        case password = "Password"
    }
}
