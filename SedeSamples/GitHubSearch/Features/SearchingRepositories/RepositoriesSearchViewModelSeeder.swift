//
// Created by Ryoichi Izumita on 2021/03/23.
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

    func initialize() -> (RepositoriesSearchView.Model, Cmd<RepositoriesSearchView.Msg>) {
        (RepositoriesSearchView.Model(searchText: "Sede",
                                      repositories: repositoryStore.repositories,
                                      title: "Sede"),
         .ofMsg(.search))
    }

    func update(model: RepositoriesSearchView.Model) -> (RepositoriesSearchView.Model, Cmd<RepositoriesSearchView.Msg>) {
        (.init(searchText: model.searchText,
               repositories: repositoryStore.repositories,
               title: model.searchText),
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
