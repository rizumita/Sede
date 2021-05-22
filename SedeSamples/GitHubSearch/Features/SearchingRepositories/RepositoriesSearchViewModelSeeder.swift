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
    @State var page = 0

    func initialize() -> Cmd<RepositoriesSearchView.Msg> {
        repositoryStore.searchText = "Sede"
        return .batch([.ofMsg(.update),
                       Task(repositoryStore.objectWillChange
                                .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main))
                           .attemptToMsg { _ in .update },
                       .ofMsg(.searchFirst)])
    }

    func receive(msg: RepositoriesSearchView.Msg) {
        let workflow = SearchRepositoriesWorkflow.workflow { searchText, page, repositories in
            repositoryStore.update(searchText: searchText, reachedPage: page, repositories: repositories)
            self.page = page
        }

        switch msg {
        case .update:
            seed.searchText = repositoryStore.searchText
            seed.repositories = repositoryStore.repositories
            seed.title = repositoryStore.searchText

        case .searchFirst:
            repositoryStore.searchText = seed.searchText
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
