import SwiftUI

struct ArticleDetailsView: View {
    let newsReaderApi: NewsReaderApi
    
    let article: Article
    
    init(
        _ article: Article,
        image: Data? = nil,
        api: NewsReaderApi = NewsReaderApiImpl.getInstance()
    ) {
        self.article = article
        self.newsReaderApi = api
        if let imageData = image {
            imageLoadingStatus = .loaded(imageData)
        }
    }
    
    @State
    var imageLoadingStatus: LoadingStatus<Data, RequestError> = .loading
    
    var body: some View {
        ScrollView {
            VStack {
                switch imageLoadingStatus {
                case .loaded(let image): Image(uiImage: UIImage(data: image) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                default:
                    Image(systemName: "photo")
                }
                
                Text(article.title)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(article.summary)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationTitle("Article")
        .onAppear {
            loadImage()
        }
    }
    
    func loadImage() {
        switch imageLoadingStatus {
        case .loaded: break
        default:
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

struct ArticleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleDetailsView(
                FakeNewsReaderApi.article,
                api: FakeNewsReaderApi.getInstance()
            )
        }
    }
}
