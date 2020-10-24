import SwiftUI

struct ArticleListItem: View {
    @ObservedObject
    var articleListItemViewModel

    init(
        _ article: Article,
        api: NewsReaderApi = NewsReaderApiImpl.getInstance()
    ) {
        articleListItemViewModel = ArticleListItemViewModel(article, api: api)
    }

    var body: some View {
        NavigationLink(destination: Text(articleListItemViewModel.article.summary)) {
            Text(articleListItemViewModel.article.title)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding()

            switch articleListItemViewModel.imageLoadingStatus {
            case .loaded(let image): Image(uiImage: UIImage(data: image) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
            default:
                Image(systemName: "photo")
            }
        }.onAppear {
            articleListItemViewModel.loadImage()
        }
    }
}

struct ArticleListItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleListItem(
                FakeNewsReaderApi.article,
                api: FakeNewsReaderApi.getInstance()
            )
        }
    }
}
