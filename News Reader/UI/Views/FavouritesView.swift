import SwiftUI

struct FavouritesView: View {
    @ObservedObject
    var newsReaderApi: NewsReaderApi = NewsReaderApiImpl.getInstance()
    
    @State
    var articleLoadingStatus: LoadingStatus<[Article], RequestError> = .loading

    var body: some View {
        VStack {
            switch articleLoadingStatus {
            case .loading: ProgressView("Loading articles, please wait...")
            case .error(let error):
                switch error {
                case .urlError: Text("Invalid URL")
                case .decodingError: Text("Received content is invalid")
                case .genericError: Text("Unknown error")
                }
            case .loaded(let articles): ScrollView {
                LazyVStack {
                    ForEach(articles) { article in
                        ArticleListItemView(article)
                    }
                }
            }
            }
        }
        .navigationTitle("Favourites")
        .onAppear {
            loadArticles()
        }
    }
    
    func loadArticles() {
        newsReaderApi.getArticles(
            onlyLikedArticles: true,
            onSuccess: { articleBatch in
                articleLoadingStatus = .loaded(articleBatch.articles)
            },
            onFailure: { error in
                articleLoadingStatus = .error(error)
            }
        )
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FavouritesView(newsReaderApi: FakeNewsReaderApi.getInstance())
        }
    }
}
