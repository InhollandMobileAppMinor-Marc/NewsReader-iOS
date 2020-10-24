import SwiftUI

@main
struct NewsReaderApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ArticleOverviewView()
            }
        }
    }
}
