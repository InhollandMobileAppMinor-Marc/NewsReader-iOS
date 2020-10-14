//
//  ContentView.swift
//  News Reader
//
//  Created by user180963 on 10/14/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject
    var newsReaderApi = NewsReaderAPI.getInstance()
    
    var body: some View {
        VStack {
            if(newsReaderApi.isAuthenticated) {
                Text("We are logged in")
            } else {
                Text("We need to log in")
                    .navigationBarItems(trailing: NavigationLink(
                        destination: Text("Login View"),
                        label: {
                            Text("Log in")
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
