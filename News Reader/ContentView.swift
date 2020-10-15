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
    
    var body: some View {
        VStack {
            if(newsReaderApi.isAuthenticated) {
                Text("We are logged in")
                    .navigationBarItems(trailing: navigationBarItemsWhenLoggedIn)
            } else {
                Text("We need to log in")
                    .navigationBarItems(trailing: NavigationLink(
                        destination: LoginView(),
                        label: {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                        }
                    ))
            }
        }.navigationTitle("News Reader")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
