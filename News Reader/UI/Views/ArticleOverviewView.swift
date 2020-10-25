import SwiftUI

struct ArticleOverviewView: View {
    @ObservedObject
    var newsReaderApi: NewsReaderApi = NewsReaderApiImpl.getInstance()
    
    @State
    var articleLoadingStatus: LoadingStatus<[Article], RequestError> = .loading
    
    @State
    private var nextBatchId: Int? = nil
    
    @State
    private var lastLoadingViewId: Int? = nil
    
    private var navigationBarItemsWhenLoggedIn: some View {
        HStack(spacing: 16) {
            Button(action: {
                newsReaderApi.logout()
            }, label: {
                Image(systemName: "escape")
            })
            
            NavigationLink(
                destination: FavouritesView(
                    newsReaderApi: newsReaderApi
                ),
                label: {
                    Image(systemName: "star")
                }
            )
        }
    }
    
    private var navigationBarItemsWhenLoggedOut: some View {
        NavigationLink(
            destination: LoginView(),
            label: {
                Image(systemName: "person.crop.circle.fill.badge.plus")
            }
        )
    }
    
    var body: some View {
        let main = VStack {
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
                        ArticleListItemView(article).onAppear {
                            if(article.id == articles.last?.id && lastLoadingViewId != article.id) {
                                lastLoadingViewId = article.id
                                loadUpcomingArticles()
                            }
                        }
                    }
                }
            }
            }
        }
        .navigationTitle("673915 - News Reader")
        .onAppear {
            loadArticles()
        }
        
        if(newsReaderApi.isAuthenticated) {
            main.navigationBarItems(trailing: navigationBarItemsWhenLoggedIn)
        } else {
            main.navigationBarItems(trailing: navigationBarItemsWhenLoggedOut)
        }
    }
    
    func loadArticles() {
        newsReaderApi.getArticles(
            onlyLikedArticles: false,
            onSuccess: { articleBatch in
                articleLoadingStatus = .loaded(articleBatch.articles)
                self.nextBatchId = articleBatch.nextId
            },
            onFailure: { error in
                articleLoadingStatus = .error(error)
            }
        )
    }
    
    func loadUpcomingArticles() {
        if let nextId = nextBatchId {
            newsReaderApi.getArticlesById(
                id: nextId,
                onSuccess: { (articleBatch) in
                    switch articleLoadingStatus {
                    case .loaded(let articles):
                        articleLoadingStatus = .loaded(articles + articleBatch.articles)
                    default: return
                    }
                    
                    self.nextBatchId = articleBatch.nextId
                },
                onFailure: { error in
                    debugPrint(error)
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleOverviewView(newsReaderApi: FakeNewsReaderApi.getInstance())
        }
    }
}
