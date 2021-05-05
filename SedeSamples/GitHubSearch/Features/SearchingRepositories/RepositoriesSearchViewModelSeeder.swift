//
// Created by 和泉田 領一 on 2021/03/23.
//

import SwiftUI
import Combine
import Sede

struct RepositoriesSearchViewModelSeeder: Seeder {
    @Environment(\.repositoryStore) var repositoryStore
    @State var cancellables = Set<AnyCancellable>()

    var observedObjects: [AnyObservableObject] {
        [_repositoryStore]
    }

    func initialize() -> RepositoriesSearchView.Model {
        RepositoriesSearchView.Model(searchText: repositoryStore.searchText,
                                     repositories: repositoryStore.repositories,
                                     appearedIndex: 0)
    }

    func update(value: RepositoriesSearchView.Model) -> RepositoriesSearchView.Model {
        .init(searchText: value.searchText,
              repositories: repositoryStore.repositories,
              appearedIndex: value.appearedIndex)
    }

    func receive(msg: RepositoriesSearchView.Msg) {
        switch msg {
        case .search(let text):
            let workflow = SearchRepositoriesWorkflow.workflow(update: repositoryStore.update)
            workflow(text: text, page: repositoryStore.reachedPage + 1)
                .subscribe(on: DispatchQueue.global())
                .sink { _ in }
                .store(in: &cancellables)

        case .loadIfNeeded(let page):
            ()
        }
    }
}
