import Foundation

final class LoginViewModel : ObservableObject {
    private let newsReaderApi: NewsReaderApi

    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>

    @State
    var username = ""

    @State
    var password = ""

    @State
    var isLoading = false

    init(api: NewsReaderApi = NewsReaderApiImpl.getInstance()) {
        self.newsReaderApi = api
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
                print(error)
            })
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
                print(error)
            })
    }
}
