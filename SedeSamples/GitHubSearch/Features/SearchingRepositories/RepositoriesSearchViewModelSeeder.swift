//
// Created by 和泉田 領一 on 2021/03/23.
//

import SwiftUI
import Combine
import Sede

struct RepositoriesSearchViewModelSeeder: Seeder {
    @Environment(\.repositoryStore) var repositoryStore
    @State var                          cancellables = Set<AnyCancellable>()
    @State var                          page         = 0

    var observedObjects: [AnyObservableObject] {
        [_repositoryStore]
    }

    func initialize() -> Diad<RepositoriesSearchView.Model, RepositoriesSearchView.Msg> {
        (RepositoriesSearchView.Model(searchText: repositoryStore.searchText,
                                      repositories: repositoryStore.repositories),
         .ofMsg(.search))
    }

    func update(model: RepositoriesSearchView.Model) -> Diad<RepositoriesSearchView.Model, RepositoriesSearchView.Msg> {
        (.init(searchText: model.searchText,
               repositories: repositoryStore.repositories),
         .none)
    }

    func receive(model: RepositoriesSearchView.Model, msg: RepositoriesSearchView.Msg) {
        switch msg {
        case .search:
            let page = model.searchText == repositoryStore.searchText ? self.page : 0
            self.page = page + 1

            let workflow = SearchRepositoriesWorkflow.workflow { searchText, page, repositories in
                repositoryStore.update(searchText: searchText,
                                       reachedPage: page,
                                       repositories: repositories)
            }
            workflow(text: model.searchText, page: repositoryStore.reachedPage + 1)
                .subscribe(on: DispatchQueue.global())
                .sink { _ in }
                .store(in: &cancellables)
        }
    }
}
