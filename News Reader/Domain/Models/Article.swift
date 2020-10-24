import Foundation

struct Article : Decodable, Identifiable {
    let id: Int
    let feed: Int
    let title: String
    let summary: String
    let publishDate: String
    let image: URL
    let url: URL
    let related: [URL]
    let categories: [Feed]
    let isLiked: Bool

    enum CodingKeys : String, CodingKey {
        case id = "Id"
        case feed = "Feed"
        case title = "Title"
        case summary = "Summary"
        case publishDate = "PublishDate"
        case image = "Image"
        case url = "Url"
        case related = "Related"
        case categories = "Categories"
        case isLiked = "IsLiked"
    }
}
