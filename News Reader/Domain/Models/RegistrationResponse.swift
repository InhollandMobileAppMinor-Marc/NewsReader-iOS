import Foundation

struct RegistrationResponse : Decodable {
    let success: Bool
    let message: String

    enum CodingKeys : String, CodingKey {
        case success = "Success"
        case message = "Message"
    }
}
