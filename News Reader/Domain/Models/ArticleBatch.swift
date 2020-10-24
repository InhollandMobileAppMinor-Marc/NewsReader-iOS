import Foundation

struct ArticleBatch : Decodable {
    let articles: [Article]
    let nextId: Int?

    enum CodingKeys : String, CodingKey {
        case articles = "Results"
        case nextId = "NextId"
    }
}
