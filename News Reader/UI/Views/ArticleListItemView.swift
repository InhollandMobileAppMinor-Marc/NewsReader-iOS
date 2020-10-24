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
    
    var imageData: Data? {
        get {
            switch imageLoadingStatus {
            case .loaded(let data): return data
            default: return nil
            }
        }
    }
    
    var body: some View {
        NavigationLink(
            destination: ArticleDetailsView(
                article,
                image: imageData,
                api: newsReaderApi
            )
        ) {
            switch imageLoadingStatus {
            case .loaded(let image):
                Image(uiImage: UIImage(data: image) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, alignment: .leading)
            default:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, alignment: .center)
            }
            
            VStack {
                Text(article.title)
                    .allowsTightening(true)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 4.0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if(article.isLiked) {
                    Image(systemName: "heart.fill")
                        .padding(.top, 2.0)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .padding(.horizontal, 8.0)
        .padding(.vertical, 2.0)
        .onAppear {
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
