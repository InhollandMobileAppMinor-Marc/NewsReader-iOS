import SwiftUI

struct LoginView: View {
    var newsReaderApi: NewsReaderApi = NewsReaderApiImpl.getInstance()
    
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @State
    var username = ""
    
    @State
    var password = ""
    
    @State
    var isLoading = false
    
    @State
    var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            if(isLoading) {
                ProgressView("Trying to login...")
            } else {
                if let error = errorMessage {
                    Text(error)
                        .font(.body)
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8.0)
                }
                
                TextField("Enter username", text: $username)
                    .padding()
                    .border(Color.gray.opacity(0.5), width: 1)
                    .cornerRadius(3.0)
                
                SecureField("Enter password", text: $password)
                    .padding()
                    .border(Color.gray.opacity(0.5), width: 1)
                    .cornerRadius(3.0)
                
                HStack {
                    Button(action: {
                        register()
                    }, label: {
                        Text("Register")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.blue)
                    })
                    .background(Color.white)
                    .cornerRadius(8.0)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 2.0))
                    
                    Button(action: {
                        login()
                    }, label: {
                        Text("Log in")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.white)
                    })
                    .background(Color.blue)
                    .cornerRadius(8.0)
                }
            }
        }
        .padding()
        .navigationTitle("Login")
    }
    
    func login() {
        isLoading = true
        newsReaderApi.login(
            username: username,
            password: password,
            onSuccess: {
                isLoading = false
                self.presentationMode.wrappedValue.dismiss()
            },
            onFailure: { (error) in
                isLoading = false
                switch error {
                case .urlError:
                    errorMessage = "Invalid URL"
                case .decodingError:
                    errorMessage = "Invalid login data"
                case .genericError:
                    errorMessage = "Unknown error"
                }
            })
    }
    
    func register() {
        isLoading = true
        newsReaderApi.register(
            username: username,
            password: password,
            onSuccess: {
                isLoading = false
                self.presentationMode.wrappedValue.dismiss()
            },
            onFailure: { (error) in
                isLoading = false
                switch error {
                case .urlError:
                    errorMessage = "Invalid URL"
                case .decodingError:
                    errorMessage = "Invalid registration data"
                case .genericError(let err):
                    if let apiError = err as? ApiError {
                        errorMessage = apiError.message
                    } else {
                        errorMessage = "Unknown error"
                    }
                }
            })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(newsReaderApi: FakeNewsReaderApi.getInstance())
        }
    }
}
