import Foundation

struct Feed : Decodable, Identifiable {
    let id: Int
    let name: String

    enum CodingKeys : String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}
