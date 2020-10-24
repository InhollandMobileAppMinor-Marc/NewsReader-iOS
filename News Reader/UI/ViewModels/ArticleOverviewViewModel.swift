import Foundation

final class ArticleOverviewViewModel : ObservableObject {
    @ObservedObject
    private(set) var newsReaderApi: NewsReaderApi

    @State
    var favouritesOnly: Bool

    @State
    var articleLoadingStatus: LoadingStatus<[Article], RequestError> = .loading

    var isAuthenticated = $newsReaderApi.isAuthenticated

    init(
        favouritesOnly: Bool = false,
        api: NewsReaderApi = NewsReaderApiImpl.getInstance()
    ) {
        self.favouritesOnly = favouritesOnly
        self.newsReaderApi = api
    }

    func logout() {
        newsReaderApi.logout()
    }

    func loadArticles() {
        newsReaderApi.getArticles(
            onlyLikedArticles: favouritesOnly,
            onSuccess: { articleBatch in
                articleLoadingStatus = .loaded(articleBatch.articles)
            },
            onFailure: { error in
                articleLoadingStatus = .error(error)
            }
        )
    }
}
