//
//  LoginView.swift
//  News Reader
//
//  Created by user180963 on 10/15/20.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @State
    var username = ""
    
    @State
    var password = ""
    
    @State
    var isLoading = false
    
    var body: some View {
        VStack {
            if(isLoading) {
                ProgressView("Trying to login...")
            } else {
                TextField("Enter username", text: $username)
                    .padding()
                    .border(Color.black.opacity(0.2), width: 1)
                    .cornerRadius(3.0)
                SecureField("Enter password", text: $password)
                    .padding()
                    .border(Color.black.opacity(0.2), width: 1)
                    .cornerRadius(3.0)
                Button(action: {
                    isLoading = true
                    NewsReaderAPI.getInstance().login(
                        username: username,
                        password: password,
                        onSuccess: {
                            isLoading = false
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        onFailure: { (error) in
                            isLoading = false
                            print(error)
                        })
                }, label: {
                    Text("Login")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .foregroundColor(.white)
                })
                .background(Color.blue)
                .cornerRadius(8.0)
            }
        }
        .padding()
        .navigationTitle("Login")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
