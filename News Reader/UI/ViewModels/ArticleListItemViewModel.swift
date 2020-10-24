import Foundation

final class ArticleListItemViewModel : ObservableObject {
    private var newsReaderApi: NewsReaderApi

    let article: Article

    @State
    var imageLoadingStatus: LoadingStatus<Data, RequestError> = .loading

    init(
        _ article: Article,
        api: NewsReaderApi = NewsReaderApiImpl.getInstance()
    ) {
        self.article = article
        self.newsReaderApi = api
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
