//
// Created by Ryoichi Izumita on 2021/03/23.
//

import SwiftUI
import Combine
import Sede

struct RepositoriesSearchViewModelSeeder: Seedable {
    @Environment(\.repositoryStore) var repositoryStore
    @Seed(RepositoriesSearchView.Model()) var seed

    func initialize() -> Cmd<RepositoriesSearchView.Msg> {
        repositoryStore.searchText = "Sede"
        return .batch([.ofMsg(.update), .ofMsg(.searchFirst)])
    }

    func receive(msg: RepositoriesSearchView.Msg) -> Cmd<RepositoriesSearchView.Msg> {
        print(String(describing: Self.self) + "." + #function)
        let workflow = SearchRepositoriesWorkflow.workflow { searchText, page, repositories in
            repositoryStore.update(searchText: searchText, reachedPage: page, repositories: repositories)
            seed.page = page
        }

        switch msg {
        case .update:
            print(repositoryStore.repositories.count)
            seed.searchText = repositoryStore.searchText
            seed.repositories = repositoryStore.repositories
            seed.title = repositoryStore.searchText
            return .none

        case .searchFirst:
            repositoryStore.searchText = seed.searchText
            repositoryStore.repositories = []
            return Task(workflow(text: seed.searchText, page: 0)
                            .subscribe(on: DispatchQueue.global()))
                .attemptToMsg { _ in .update }

        case .searchNext:
            return Task(workflow(text: seed.searchText, page: seed.page + 1)
                            .subscribe(on: DispatchQueue.global()))
                .attemptToMsg { _ in .update }
        }
    }
}
