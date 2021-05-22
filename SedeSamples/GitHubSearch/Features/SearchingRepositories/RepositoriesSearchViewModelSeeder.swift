//
// Created by Ryoichi Izumita on 2021/03/23.
//

import SwiftUI
import Combine
import Sede

struct RepositoriesSearchViewModelSeeder: Seedable {
    @Environment(\.repositoryStore) var repositoryStore
    @State var seed = RepositoriesSearchView.Model()
    @State var page = 0

    func initialize() -> Cmd<RepositoriesSearchView.Msg> {
        repositoryStore.searchText = "Sede"
        return .batch([.ofMsg(.update), .ofMsg(.searchFirst)])
    }

    func receive(msg: RepositoriesSearchView.Msg) -> Cmd<RepositoriesSearchView.Msg> {
        let workflow = SearchRepositoriesWorkflow.workflow { searchText, page, repositories in
            repositoryStore.update(searchText: searchText, reachedPage: page, repositories: repositories)
            self.page = page
        }

        switch msg {
        case .update:
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
            let page = self.page + 1
            return Task(workflow(text: seed.searchText, page: page)
                            .subscribe(on: DispatchQueue.global()))
                .attemptToMsg { _ in .update }
        }
    }
}
