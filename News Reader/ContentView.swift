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
    var articles: [Article] = []
    
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
        VStack {
            let list = List(articles) { article in
                Text(article.title)
                    .padding()
            }
            if(newsReaderApi.isAuthenticated) {
                list.navigationBarItems(trailing: navigationBarItemsWhenLoggedIn)
            } else {
                list.navigationBarItems(trailing: navigationBarItemsWhenLoggedOut)
            }
        }
        .padding()
        .navigationTitle("News Reader")
        .onAppear {
            print("Fetching articles")
            newsReaderApi.getArticles(
                onSuccess: { articleBatch in
                    print("Articles received \(articleBatch.articles.count)")
                    self.articles = articleBatch.articles
                },
                onFailure: { error in
                    print(error)
                }
            )
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
