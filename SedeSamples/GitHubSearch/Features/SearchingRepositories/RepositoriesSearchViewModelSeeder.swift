//
// Created by Ryoichi Izumita on 2021/03/23.
//

import SwiftUI
import Combine
import Sede

struct RepositoriesSearchViewModelSeeder: Seedable {
    @Environment(\.repositoryStore) var repositoryStore
    @Seed var seed = RepositoriesSearchView.Model()
    @Seed var cancellables = Set<AnyCancellable>()
    @Seed var page = 0
    var objectWillChange: some Publisher {
        repositoryStore.objectWillChange
        seed.objectWillChange
    }

    func initialize() -> Cmd<RepositoriesSearchView.Msg> {
        seed.searchText = "Sede"
        seed.repositories = repositoryStore.repositories
        seed.title = "Sede"
        return .ofMsg(.searchFirst)
    }

    func receive(msg: RepositoriesSearchView.Msg) {
        let workflow = SearchRepositoriesWorkflow.workflow { searchText, page, repositories in
            repositoryStore.update(searchText: searchText,
                                   reachedPage: page,
                                   repositories: repositories)
            seed.searchText = searchText
            seed.repositories = repositoryStore.repositories
            seed.title = searchText
            self.page = page
        }

        switch msg {
        case .searchFirst:
            repositoryStore.repositories = []
            workflow(text: seed.searchText, page: 0)
                .subscribe(on: DispatchQueue.global())
                .sink { _ in }
                .store(in: &cancellables)

        case .searchNext:
            let page = self.page + 1
            workflow(text: seed.searchText, page: page)
                .subscribe(on: DispatchQueue.global())
                .sink { _ in }
                .store(in: &cancellables)
        }
    }
}
