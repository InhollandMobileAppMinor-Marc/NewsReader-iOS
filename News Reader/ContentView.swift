//
//  ContentView.swift
//  News Reader
//
//  Created by user180963 on 10/14/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject
    private var newsReaderApi = NewsReaderAPI.getInstance()
    
    @State
    var articleLoadingStatus: LoadingStatus<[Article], RequestError> = .loading
    
    private var navigationBarItemsWhenLoggedIn: some View {
        HStack(spacing: 16) {
            Button(action: {
                newsReaderApi.logout()
            }, label: {
                Image(systemName: "escape")
            })
            
            Button(action: {
                print("Favorites")
            }, label: {
                Image(systemName: "star")
            })
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
                        ArticleListItem(article: article)
                    }
                }
            }
            }
        }
        .navigationTitle("News Reader")
        .onAppear {
            newsReaderApi.getArticles(
                onSuccess: { articleBatch in
                    articleLoadingStatus = .loaded(articleBatch.articles)
                },
                onFailure: { error in
                    articleLoadingStatus = .error(error)
                }
            )
        }
        
        if(newsReaderApi.isAuthenticated) {
            main.navigationBarItems(trailing: navigationBarItemsWhenLoggedIn)
        } else {
            main.navigationBarItems(trailing: navigationBarItemsWhenLoggedOut)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
