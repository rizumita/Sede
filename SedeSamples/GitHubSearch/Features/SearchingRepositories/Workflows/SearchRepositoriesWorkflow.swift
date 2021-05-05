//
// Created by 和泉田 領一 on 2021/03/23.
//

import Foundation
import Combine

enum SearchRepositoriesWorkflow {
    enum WorkflowError: Error {
        case invalidLengthOfSearchText(Int)
        case unableToGenerateURL
        case dataTaskError(Error)
        case decodingError(Error)
    }

    enum Events {
        case success(String, Int, [Repository])
        case failure(WorkflowError)
    }

    struct Execute {
        var update: (String, Int, [Repository]) -> ()

        @discardableResult
        func callAsFunction(text: String, page: Int) -> AnyPublisher<Events, Never> {
            validate(text: text)
                .flatMap { generateURL(text: $0, page: page) }
                .publisher
                .flatMap(search(url:))
                .map(\.repositories)
                .map { (text, page, $0) }
                .handleEvents(receiveOutput: update)
                .map(Events.success)
                .catch { Just<Events>(.failure($0)) }
                .eraseToAnyPublisher()
        }
    }

    static func workflow(update: @escaping (String, Int, [Repository]) -> ()) -> Execute {
        Execute(update: update)
    }

    static func validate(text: String) -> Result<String, WorkflowError> {
        guard 1...100 ~= text.count else { return .failure(.invalidLengthOfSearchText(text.count)) }
        return .success(text)
    }

    static func generateURL(text: String, page: Int) -> Result<URL, WorkflowError> {
        var components = URLComponents(string: "https://api.github.com/search/repositories")
        components?.queryItems = [
            URLQueryItem(name: "q", value: text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)),
            URLQueryItem(name: "page", value: page.description)
        ]

        guard let url = components?.url else { return .failure(.unableToGenerateURL) }
        return .success(url)
    }

    static func search(url: URL) -> AnyPublisher<RepositorySearchResult, WorkflowError> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError(WorkflowError.dataTaskError)
            .decode(type: RepositorySearchResult.self, decoder: JSONDecoder())
            .mapError(WorkflowError.decodingError)
            .eraseToAnyPublisher()
    }
}

struct RepositorySearchResult: Decodable {
    var repositories: [Repository]

    private enum CodingKeys: String, CodingKey {
        case repositories = "items"
    }
}
