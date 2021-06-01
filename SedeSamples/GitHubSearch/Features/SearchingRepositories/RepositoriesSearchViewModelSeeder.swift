//
// Created by Ryoichi Izumita on 2021/03/23.
//

import SwiftUI
import Combine
import Sede

struct RepositoriesSearchViewModelSeeder: Seedable {
    @Environment(\.repositoryStore) var repositoryStore
    @Seeded<RepositoriesSearchView.Model, RepositoriesSearchView.Msg> var seed

    func initialize() -> RepositoriesSearchView.Model {
        repositoryStore.searchText = "Sede"
        defer { seed(Msg.update, Msg.searchFirst) }
        return .init()
    }

    func receive(msg: RepositoriesSearchView.Msg) {
        let workflow = SearchRepositoriesWorkflow.workflow { searchText, page, repositories in
            repositoryStore.update(searchText: searchText, reachedPage: page, repositories: repositories)
            seed.page = page
        }

        switch msg {
        case .update:
            seed.searchText = repositoryStore.searchText
            seed.repositories = repositoryStore.repositories
            seed.title = repositoryStore.searchText

        case .searchFirst:
            repositoryStore.searchText = seed.searchText
            repositoryStore.repositories = []
            seed(Task(workflow(text: seed.searchText, page: 0)
                          .subscribe(on: DispatchQueue.global()))
                     .attemptToMsg { _ in .update })

        case .searchNext:
            seed(Task(workflow(text: seed.searchText, page: seed.page + 1)
                          .subscribe(on: DispatchQueue.global()))
                     .attemptToMsg { _ in .update })
        }
    }
}
