import SwiftUI

struct LoginView: View {
    @ObservedObject
    var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            if(viewModel.isLoading) {
                ProgressView("Trying to login...")
            } else {
                TextField("Enter username", text: $viewModel.username)
                    .padding()
                    .border(Color.black.opacity(0.2), width: 1)
                    .cornerRadius(3.0)

                SecureField("Enter password", text: $viewModel.password)
                    .padding()
                    .border(Color.black.opacity(0.2), width: 1)
                    .cornerRadius(3.0)

                HStack {
                    Button(action: {
                        viewModel.register()
                    }, label: {
                        Text("Register")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.blue)
                    })
                    .background(Color.white)
                    .cornerRadius(8.0)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 2.0))

                    Button(action: {
                        viewModel.login()
                    }, label: {
                        Text("Login")
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(viewModel: LoginViewModel(api: FakeNewsReaderApi.getInstance()))
        }
    }
}
