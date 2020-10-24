import SwiftUI

struct ArticleOverviewView: View {
    @ObservedObject
    var articleOverviewViewModel = ArticleOverviewViewModel()

    private var navigationBarItemsWhenLoggedIn: some View {
        HStack(spacing: 16) {
            Button(action: {
                articleOverviewViewModel.logout()
            }, label: {
                Image(systemName: "escape")
            })

            NavigationLink(
                destination: ArticleOverviewView(
                    articleOverviewViewModel: ArticleOverviewViewModel(
                        favouritesOnly: true,
                        api: articleOverviewViewModel.newsReaderApi
                    )
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
            switch articleOverviewViewModel.articleLoadingStatus {
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
                        ArticleListItem(article)
                    }
                }
            }
            }
        }
        .navigationTitle(articleOverviewViewModel.favouritesOnly ? "Favourites" : "673915 - News Reader")
        .onAppear {
            articleOverviewViewModel.loadArticles()
        }

        if(articleOverviewViewModel.isAuthenticated) {
            main.navigationBarItems(trailing: navigationBarItemsWhenLoggedIn)
        } else {
            main.navigationBarItems(trailing: navigationBarItemsWhenLoggedOut)
        }
    }
}

struct ArticleOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleOverviewView(
                articleOverviewViewModel: ArticleOverviewViewModel(
                    favouritesOnly: false,
                    api: FakeNewsReaderApi.getInstance()
                )
            )
        }
    }
}
