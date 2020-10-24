import SwiftUI

struct ArticleListItemView: View {
    let newsReaderApi: NewsReaderApi
    
    let article: Article
    
    init(
        _ article: Article,
        api: NewsReaderApi = NewsReaderApiImpl.getInstance()
    ) {
        self.article = article
        self.newsReaderApi = api
    }
    
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
            loadImage()
        }
    }
    
    func loadImage() {
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

struct ArticleListItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleListItemView(
                FakeNewsReaderApi.article,
                api: FakeNewsReaderApi.getInstance()
            )
        }
    }
}
