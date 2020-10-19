//
//  ArticleListItem.swift
//  News Reader
//
//  Created by user180963 on 19/10/2020.
//

import SwiftUI

struct ArticleListItem: View {
    private let newsReaderApi = NewsReaderAPI.getInstance()
    
    let article: Article
    
    @State
    var imageLoadingStatus: LoadingStatus<Data, RequestError> = .loading
    
    var body: some View {
        NavigationLink(destination: Text(article.summary)) {
            Text(article.title)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding()
            
            switch imageLoadingStatus {
            case .loaded(let image): Image(uiImage: UIImage(data: image) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
            default:
                Image(systemName: "photo")
            }
        }.onAppear {
            newsReaderApi.getImage(
                ofImageUrl: article.image,
                onSuccess: { image in
                    self.imageLoadingStatus = .loaded(image)
                },
                onFailure: { error in
                    debugPrint(error)
                    print("Failure")
                }
            )
        }
    }
}

struct ArticleListItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleListItem(article: Article(
                id: 1,
                feed: 1,
                title: "Hello world!",
                summary: "Lorem ipsum",
                publishDate: "2020-10-19T12:00",
                image: URL(string: "https://marketplace.canva.com/MAB_ajIqclg/1/0/thumbnail_large/canva-hello-world-instagram-post-MAB_ajIqclg.jpg")!,
                url: URL(string: "https://example.com/")!,
                related: [],
                categories: [],
                isLiked: false
            ))
        }
    }
}
