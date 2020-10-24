import Foundation

enum LoadingStatus<T, ErrorType> {
    case loading
    case loaded(T)
    case error(ErrorType)
}
